import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// The heading above a list: what the list is and how many it holds, with a
/// dotted line under it that separates it from the rows.
class ListHeader extends StatelessWidget {
  const ListHeader({super.key, required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: context.text.titleMedium)),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.brand.primaryLight,
                borderRadius: AppRadius.pillAll,
              ),
              child: Text(
                '$count',
                style: context.text.labelMedium!.copyWith(
                  color: context.brand.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const DottedLine(),
      ],
    );
  }
}

/// A thin line made of dots.
class DottedLine extends StatelessWidget {
  const DottedLine({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 2,
    width: double.infinity,
    child: CustomPaint(
      painter: _DotsPainter(AppColors.textMuted.withValues(alpha: 0.5)),
    ),
  );
}

class _DotsPainter extends CustomPainter {
  const _DotsPainter(this.color);

  final Color color;

  static const _radius = 1.0;
  static const _gap = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var x = _radius; x < size.width; x += _gap) {
      canvas.drawCircle(Offset(x, size.height / 2), _radius, paint);
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => oldDelegate.color != color;
}
