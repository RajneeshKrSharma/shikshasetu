import '../theme/app_colors.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';
import 'shared_widgets.dart';

/// Makes a sideways scroller obvious: an optional heading, an arrow on its own
/// white disc beside the items (tap it to scroll on), a scroll bar under the items (in the brand
/// color), and a "scroll to view more" line. The arrow, bar and line appear
/// only while there is more to scroll to, and take no room otherwise.
///
/// By default it is all inside one card (for tiles such as the dashboard's).
/// Set [bordered] to false for a row of filter chips: boxed in a card it looks
/// like a field to fill in.
///
/// [builder] returns the scrollable (give it a bounded height) and must use
/// the controller it is handed.
class ScrollHint extends StatefulWidget {
  const ScrollHint({
    super.key,
    required this.builder,
    this.itemCount,
    this.title,
    this.bordered = true,
  });

  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  /// How many items there are, shown next to the hint when given.
  final int? itemCount;

  /// A heading shown top-left inside the card, above the scroller.
  final String? title;

  /// Wrap it all in a card.
  final bool bordered;

  @override
  State<ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<ScrollHint> {
  late final ScrollController _controller;

  /// The scroller's latest measurements; null until it has reported them.
  late final ValueNotifier<ScrollMetrics?> _metrics;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _metrics = ValueNotifier(null);
  }

  @override
  void dispose() {
    _controller.dispose();
    _metrics.dispose();
    super.dispose();
  }

  /// Scrolls most of a screen's width further.
  void _scrollOn() {
    final m = _metrics.value;
    if (m == null || !_controller.hasClients) return;
    _controller.animateTo(
      (m.pixels + m.viewportDimension * 0.8).clamp(0.0, m.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  bool _onScroll(ScrollMetrics metrics) {
    _metrics.value = metrics;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null) SectionTitle(widget.title!),
        // The scroller, and at its end a slot for the arrow: the arrow sits
        // beside the items, never on top of them, and is a button that scrolls
        // on. The slot is there only while there is more to scroll to.
        Row(
          children: [
            Expanded(child: widget.builder(context, _controller)),
            ValueListenableBuilder<ScrollMetrics?>(
              valueListenable: _metrics,
              builder: (context, m, _) {
                final more = m != null && m.extentAfter > 1;
                if (!more) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.md,
                  ),
                  child: Material(
                    color: AppColors.surface,
                    shape: CircleBorder(
                      side: BorderSide(color: AppColors.border),
                    ),
                    elevation: 1,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _scrollOn,
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.chevron_right, color: brand.primary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        // The bar and the hint take room only when there is more to scroll
        // to; otherwise nothing is reserved for them.
        ValueListenableBuilder<ScrollMetrics?>(
          valueListenable: _metrics,
          builder: (context, m, _) {
            final overflows = m != null && (m.extentBefore + m.extentAfter) > 1;
            if (!overflows) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                _Track(metrics: _metrics),
                AnimatedOpacity(
                  opacity: m.extentAfter > 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      widget.itemCount == null
                          ? context.l10n.scrollForMore
                          : context.l10n.scrollForMoreCount(widget.itemCount!),
                      textAlign: TextAlign.end,
                      style: context.text.labelSmall!.copyWith(
                        color: brand.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) => _onScroll(n.metrics),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onScroll(n.metrics),
        child: widget.bordered
            ? AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: content,
              )
            : content,
      ),
    );
  }
}

/// The scroll bar: a grey track with a brand-colored thumb showing how much of
/// the list is in view and where. It sits under the items, never over them.
class _Track extends StatelessWidget {
  const _Track({required this.metrics});

  final ValueListenable<ScrollMetrics?> metrics;

  static const _height = 5.0;

  @override
  Widget build(BuildContext context) {
    final color = context.brand.primary;
    return ValueListenableBuilder<ScrollMetrics?>(
      valueListenable: metrics,
      builder: (context, m, _) {
        if (m == null || (m.extentBefore + m.extentAfter) <= 1) {
          return const SizedBox(height: _height);
        }
        final total = m.extentBefore + m.extentInside + m.extentAfter;
        final share = (m.extentInside / total).clamp(0.08, 1.0);
        final position = m.extentBefore / (m.extentBefore + m.extentAfter);
        return LayoutBuilder(
          builder: (context, box) {
            final thumb = box.maxWidth * share;
            return SizedBox(
              height: _height,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(_height),
                    ),
                  ),
                  PositionedDirectional(
                    start: (box.maxWidth - thumb) * position.clamp(0.0, 1.0),
                    width: thumb,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(_height),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
