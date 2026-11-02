import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/accessory_kind.dart';
import '../../domain/entities/issue_draft.dart';

extension AccessoryKindLabel on AccessoryKind {
  String label(AppLocalizations l) => switch (this) {
    AccessoryKind.dress => l.accKindDress,
    AccessoryKind.books => l.accKindBooks,
  };

  String setTitle(AppLocalizations l) => switch (this) {
    AccessoryKind.dress => l.accSetDress,
    AccessoryKind.books => l.accSetBooks,
  };

  String setHint(AppLocalizations l) => switch (this) {
    AccessoryKind.dress => l.accSetHintDress,
    AccessoryKind.books => l.accSetHintBooks,
  };

  String issueTitle(AppLocalizations l) => switch (this) {
    AccessoryKind.dress => l.accIssueTitleDress,
    AccessoryKind.books => l.accIssueTitleBooks,
  };

  String giveLabel(AppLocalizations l) => switch (this) {
    AccessoryKind.dress => l.accIssue,
    AccessoryKind.books => l.accGive,
  };
}

extension IssueProblemMessage on IssueProblem {
  String message(AppLocalizations l) => switch (this) {
    IssueProblem.noItems => l.accProblemNoItems,
    IssueProblem.receiverMissing => l.accProblemReceiver,
    IssueProblem.signatureMissing => l.accProblemSignature,
    IssueProblem.sizeMissing => l.accProblemSize,
  };
}
