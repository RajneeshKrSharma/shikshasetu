import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../domain/entities/scanned_question.dart';
import '../../domain/repository/question_scanner_repository.dart';
import 'ocr_layout.dart';

/// On-device OCR with Google ML Kit. Works offline; nothing is uploaded.
class MlKitQuestionScannerRepository implements QuestionScannerRepository {
  @override
  Future<String> recognize(
    String imagePath, {
    required ScanScript script,
  }) async {
    final recognizer = TextRecognizer(
      script: switch (script) {
        ScanScript.latin => TextRecognitionScript.latin,
        ScanScript.devanagari => TextRecognitionScript.devanagiri,
      },
    );
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      return ocrLayoutText([
        for (final block in result.blocks)
          for (final line in block.lines)
            OcrLine(
              line.text,
              line.boundingBox.left,
              line.boundingBox.top,
              line.boundingBox.right,
              line.boundingBox.bottom,
            ),
      ]);
    } finally {
      await recognizer.close();
    }
  }
}
