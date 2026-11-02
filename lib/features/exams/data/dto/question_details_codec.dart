import 'dart:convert';

import '../../domain/entities/exam_paper.dart';

/// The type-specific part of a question, stored as one JSON column so a new
/// question type needs no new column.
class QuestionDetailsCodec {
  const QuestionDetailsCodec._();

  /// Null when the question has nothing beyond its text and marks.
  static String? encode(Question q) {
    final map = <String, Object?>{
      if (q.options.isNotEmpty) 'options': q.options,
      if (q.correctIndex != null) 'correct': q.correctIndex,
      if (q.pairs.isNotEmpty)
        'pairs': [
          for (final p in q.pairs) [p.left, p.right],
        ],
      if (q.answer.isNotEmpty) 'answer': q.answer,
    };
    return map.isEmpty ? null : jsonEncode(map);
  }

  static Question decode({
    required String text,
    required int marks,
    required String type,
    String? details,
  }) {
    final map = details == null || details.isEmpty
        ? const <String, dynamic>{}
        : jsonDecode(details) as Map<String, dynamic>;
    return Question(
      text: text,
      marks: marks,
      type: QuestionType.parse(type),
      options: [for (final o in map['options'] as List? ?? const []) '$o'],
      correctIndex: map['correct'] as int?,
      pairs: [
        for (final p in map['pairs'] as List? ?? const [])
          MatchPair('${(p as List)[0]}', '${p[1]}'),
      ],
      answer: map['answer'] as String? ?? '',
    );
  }
}
