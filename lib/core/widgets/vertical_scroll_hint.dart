import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// Makes a long list obvious: a scroll bar that stays in view, with a gap
/// above and below it, and a "Scroll to view more" bubble at the bottom while
/// there is more below. [builder] returns the scrollable and must use the
/// controller it is handed.
class VerticalScrollHint extends StatefulWidget {
  const VerticalScrollHint({super.key, required this.builder});

  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  @override
  State<VerticalScrollHint> createState() => _VerticalScrollHintState();
}

class _VerticalScrollHintState extends State<VerticalScrollHint> {
  late final ScrollController _controller;

  /// The list's latest measurements; null until it has reported them.
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

  bool _onScroll(ScrollMetrics metrics) {
    _metrics.value = metrics;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) => _onScroll(n.metrics),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onScroll(n.metrics),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                interactive: true,
                child: widget.builder(context, _controller),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.md,
              child: IgnorePointer(
                child: ValueListenableBuilder<ScrollMetrics?>(
                  valueListenable: _metrics,
                  builder: (context, m, _) => AnimatedOpacity(
                    opacity: m != null && m.extentAfter > 1 ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs + 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.brand.primary,
                          borderRadius: AppRadius.pillAll,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.l10n.scrollForMore,
                              style: context.text.labelMedium!.copyWith(
                                color: AppColors.surface,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: AppIconSize.sm,
                              color: AppColors.surface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
