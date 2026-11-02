import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/exam_paper.dart';

extension QuestionTypeStyle on QuestionType {
  String label(AppLocalizations l) => switch (this) {
    QuestionType.mcq => l.qtMcq,
    QuestionType.trueFalse => l.qtTrueFalse,
    QuestionType.fillBlank => l.qtFillBlank,
    QuestionType.matchFollowing => l.qtMatch,
    QuestionType.shortAnswer => l.qtShort,
    QuestionType.longAnswer => l.qtLong,
  };

  String hint(AppLocalizations l) => switch (this) {
    QuestionType.mcq => l.qtMcqHint,
    QuestionType.trueFalse => l.qtTrueFalseHint,
    QuestionType.fillBlank => l.qtFillBlankHint,
    QuestionType.matchFollowing => l.qtMatchHint,
    QuestionType.shortAnswer => l.qtShortHint,
    QuestionType.longAnswer => l.qtLongHint,
  };

  IconData get icon => switch (this) {
    QuestionType.mcq => Icons.checklist_rtl,
    QuestionType.trueFalse => Icons.rule,
    QuestionType.fillBlank => Icons.edit_note,
    QuestionType.matchFollowing => Icons.compare_arrows,
    QuestionType.shortAnswer => Icons.short_text,
    QuestionType.longAnswer => Icons.notes,
  };
}
