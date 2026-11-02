import 'package:flutter/widgets.dart';

/// Spacing scale. Use these instead of raw numbers in widgets.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const EdgeInsets page = EdgeInsets.all(lg);
  static const EdgeInsets card = EdgeInsets.all(md);

  /// [page] for a scrolling screen: leaves room under the last item for the
  /// phone's navigation bar / gesture area, and (with [fab]) for a floating
  /// button, so nothing is ever hidden behind them.
  static EdgeInsets pageOf(BuildContext context, {bool fab = false}) =>
      EdgeInsets.fromLTRB(
        lg,
        lg,
        lg,
        lg + MediaQuery.paddingOf(context).bottom + (fab ? 72 : 0),
      );
}

class AppRadius {
  AppRadius._();

  static const double sm = 6;
  static const double md = 8;
  static const double lg = 10;
  static const double pill = 14;

  /// The rounded top of a bar or sheet that rises from the screen's bottom.
  static const double sheet = 20;

  static BorderRadius get sheetTop =>
      const BorderRadius.vertical(top: Radius.circular(sheet));

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get pillAll => BorderRadius.circular(pill);
}

/// Icon sizes. Use these, never a number: small inside text and buttons,
/// medium as the default, large in bars, extra large for a feature mark, and
/// hero in an empty state.
class AppIconSize {
  AppIconSize._();

  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double hero = 48;
}

class AppSizes {
  AppSizes._();

  /// Every full-width button.
  static const double buttonHeight = 48;

  /// A button that sits inside a card or a banner.
  static const double buttonCompact = 36;

  /// A button in a dialog's action row.
  static const Size dialogButton = Size(88, 44);
  static const double iconBadge = 20;
  static const double maxFormWidth = 420;

  /// Widest a reading or editing column grows on a tablet.
  static const double maxContentWidth = 720;
}
