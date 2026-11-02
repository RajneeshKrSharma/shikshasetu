import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../../../../../features/exams/domain/entities/exam_paper.dart';
import '../../../../../features/exams/domain/entities/scanned_question.dart';
import '../../domain/entities/paper_read_failure.dart';
import '../../domain/repository/ai_key_repository.dart';
import '../../domain/repository/question_reader_repository.dart';

/// Reads a handwritten paper with Google's Gemini vision model. The reply is
/// forced into a fixed JSON shape, so the questions arrive already separated.
class GeminiQuestionReader implements QuestionReaderRepository {
  GeminiQuestionReader(this._keys, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 90),
              sendTimeout: const Duration(seconds: 120),
            ),
          );

  final AiKeyRepository _keys;
  final Dio _dio;

  /// The one place to change if Google retires this model.
  static const model = 'gemini-3.8-flash';
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';

  /// Inline pictures may total about 20 MB per request.
  static const _maxTotalBytes = 14 * 1024 * 1024;

  static const _prompt = '''
These are photos of the pages of a handwritten school question paper, in order. The writing is English, Hindi (Devanagari), or both. A photo may be tilted or upside down.

Return every question, in the order written, continuing across pages.
- Copy each question exactly as written, in its own language. Do not translate, correct or add anything. Where a word is unclear, write [?] in its place.
- Write maths in LaTeX.
- Remove the question number or label ("Ques-3", "(4)", "प्र०2", "१-") from the text.
- Skip titles, class, subject, date, headings such as "Grammar" or "Answer the following questions", and anything crossed out.
- A question that wraps onto a second line is still one question.
- type: "mcq" when choices are given (put the choices, without their letters, in options); "fillBlank" when it has a blank (write the blank as _____); "trueFalse" for a true or false statement; "matchFollowing" for a match-the-columns question (put each row in pairs, left item and right item, in the order written; put the instruction as the text); otherwise "shortAnswer".
- marks: the marks written for the question, or 0 when none are written.
''';

  static const _schema = {
    'type': 'OBJECT',
    'properties': {
      'questions': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'text': {'type': 'STRING'},
            'type': {
              'type': 'STRING',
              'enum': [
                'shortAnswer',
                'mcq',
                'fillBlank',
                'trueFalse',
                'matchFollowing',
              ],
            },
            'options': {
              'type': 'ARRAY',
              'items': {'type': 'STRING'},
            },
            'pairs': {
              'type': 'ARRAY',
              'items': {
                'type': 'OBJECT',
                'properties': {
                  'left': {'type': 'STRING'},
                  'right': {'type': 'STRING'},
                },
                'required': ['left', 'right'],
              },
            },
            'marks': {'type': 'INTEGER'},
          },
          'required': ['text', 'type'],
        },
      },
    },
    'required': ['questions'],
  };

  @override
  Future<List<ScannedQuestion>> read(List<String> imagePaths) async {
    final key = await _keys.load();
    if (key == null || key.isEmpty) {
      throw const PaperReadException(PaperReadFailure.missingKey);
    }
    final body = {
      'contents': [
        {
          'parts': [
            {'text': _prompt},
            ...await _pictures(imagePaths),
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0,
        'responseMimeType': 'application/json',
        'responseSchema': _schema,
      },
    };
    final response = await _post(key, body);
    return _questionsIn(response.data);
  }

  /// Busy-server answers (503 and its cousins) are usually
  /// gone in seconds, so they are retried a few times before giving up.
  Future<Response<dynamic>> _post(String key, Map<String, Object?> body) async {
    for (var attempt = 0; ; attempt++) {
      try {
        return await _dio.post<dynamic>(
          _endpoint,
          options: Options(
            headers: {'x-goog-api-key': key},
            contentType: Headers.jsonContentType,
          ),
          data: body,
        );
      } on DioException catch (e) {
        final retryable = _busyStatuses.contains(e.response?.statusCode);
        if (!retryable || attempt >= _retryDelays.length) throw _failureOf(e);
        await Future<void>.delayed(_retryDelays[attempt]);
      }
    }
  }

  static const _busyStatuses = {500, 502, 503, 504};
  static const _retryDelays = [
    Duration(seconds: 3),
    Duration(seconds: 6),
    Duration(seconds: 12),
  ];

  Future<List<Map<String, Object?>>> _pictures(List<String> paths) async {
    final parts = <Map<String, Object?>>[];
    var total = 0;
    for (final path in paths) {
      final bytes = await File(path).readAsBytes();
      total += bytes.length;
      if (total > _maxTotalBytes) {
        throw const PaperReadException(PaperReadFailure.tooLarge);
      }
      parts.add({
        'inline_data': {
          'mime_type': _mimeOf(path),
          'data': base64Encode(bytes),
        },
      });
    }
    return parts;
  }

  String _mimeOf(String path) => switch (p.extension(path).toLowerCase()) {
    '.png' => 'image/png',
    '.webp' => 'image/webp',
    '.heic' => 'image/heic',
    '.heif' => 'image/heif',
    _ => 'image/jpeg',
  };

  PaperReadException _failureOf(DioException e) {
    final status = e.response?.statusCode;
    debugPrint('Gemini read failed: ${e.type} $status ${e.response?.data}');
    if (status == null) {
      return PaperReadException(
        e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout
            ? PaperReadFailure.timedOut
            : PaperReadFailure.noInternet,
        e.type.name,
      );
    }
    final message = _errorMessage(e.response?.data);
    return switch (status) {
      400 when (message ?? '').toLowerCase().contains('api key') =>
        const PaperReadException(PaperReadFailure.invalidKey),
      401 || 403 => const PaperReadException(PaperReadFailure.invalidKey),
      413 => const PaperReadException(PaperReadFailure.tooLarge),
      429 => const PaperReadException(PaperReadFailure.quotaExceeded),
      500 ||
      502 ||
      503 ||
      504 => const PaperReadException(PaperReadFailure.serviceBusy),
      _ => PaperReadException(
        PaperReadFailure.serviceError,
        '$status${message == null ? '' : ': $message'}',
      ),
    };
  }

  String? _errorMessage(Object? body) {
    if (body is Map && body['error'] is Map) {
      return (body['error'] as Map)['message']?.toString();
    }
    return null;
  }

  List<ScannedQuestion> _questionsIn(Object? body) {
    try {
      final candidates = (body as Map)['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        final block = (body['promptFeedback'] as Map?)?['blockReason'];
        throw PaperReadException(
          PaperReadFailure.badReply,
          block == null ? null : '$block',
        );
      }
      final parts =
          ((candidates.first as Map)['content'] as Map)['parts'] as List;
      final json = jsonDecode(parts.map((x) => (x as Map)['text']).join());
      return [
        for (final raw in (json as Map)['questions'] as List)
          ?_questionOf(raw as Map),
      ];
    } on PaperReadException {
      rethrow;
    } catch (_) {
      throw const PaperReadException(PaperReadFailure.badReply);
    }
  }

  ScannedQuestion? _questionOf(Map raw) {
    final text = '${raw['text'] ?? ''}'.trim();
    if (text.isEmpty) return null;
    final marks = raw['marks'];
    return ScannedQuestion(
      text: text,
      marks: marks is int && marks > 0 ? marks : null,
      type: QuestionType.parse('${raw['type']}'),
      options: [
        for (final o in (raw['options'] as List? ?? const []))
          if ('$o'.trim().isNotEmpty) '$o'.trim(),
      ],
      pairs: [
        for (final pair in (raw['pairs'] as List? ?? const []))
          MatchPair(
            '${(pair as Map)['left']}'.trim(),
            '${pair['right']}'.trim(),
          ),
      ],
    );
  }
}
