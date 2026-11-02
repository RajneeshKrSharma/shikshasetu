import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/accessory.dart';

extension AccessoryKindLabel on AccessoryKind {
  String label(AppLocalizations l) => switch (this) {
    AccessoryKind.dress => l.itemKindDress,
    AccessoryKind.books => l.itemKindBooks,
  };
}
