import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/fees.dart';

extension FeeHeadLabel on FeeHead {
  String label(AppLocalizations l) => switch (this) {
    FeeHead.tuition => l.feeHeadTuition,
    FeeHead.van => l.feeHeadVan,
    FeeHead.dress => l.feeHeadDress,
    FeeHead.books => l.feeHeadBooks,
  };
}
