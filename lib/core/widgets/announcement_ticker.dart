import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// A message that runs along the top, right to left, over and over, with a
/// light sweeping through the letters. Used for the Principal's announcement.
/// With [onStop] a small cross lets the Principal stop it.
class AnnouncementTicker extends StatefulWidget {
  const AnnouncementTicker({super.key, required this.text, this.onStop});

  final String text;
  final VoidCallback? onStop;

  /// How tall the strip is.
  static const double height = 44;

  @override
  State<AnnouncementTicker> createState() => _AnnouncementTickerState();
}

class _AnnouncementTickerState extends State<AnnouncementTicker>
    with TickerProviderStateMixin {
  /// 0 → 1 once across the strip.
  late final AnimationController _run;

  /// 0 → 1, the light sweeping through the text.
  late final AnimationController _shine;

  /// 0 → 1, the megaphone ringing once, then resting a moment.
  late final AnimationController _ring;

  /// Pixels the text moves in a second.
  static const _speed = 55.0;

  double _viewport = 0;
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _run = AnimationController(vsync: this);
    _shine = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();
  }

  @override
  void dispose() {
    _run.dispose();
    _shine.dispose();
    _ring.dispose();
    super.dispose();
  }

  /// Restarts the run when the message or the width changed.
  void _measured(double viewport, double textWidth) {
    if (viewport == _viewport && textWidth == _textWidth) return;
    _viewport = viewport;
    _textWidth = textWidth;
    final seconds = (viewport + textWidth) / _speed;
    _run
      ..duration = Duration(milliseconds: (seconds * 1000).round())
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    // Bold and a little larger, so it is noticed.
    final style = context.text.labelLarge!.copyWith(
      color: brand.onPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.3,
    );
    final still = MediaQuery.disableAnimationsOf(context);

    return Material(
      color: brand.primary,
      child: SizedBox(
        height: AnnouncementTicker.height,
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.md),
            _RingingMegaphone(
              animation: _ring,
              color: brand.onPrimary,
              still: still,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) {
                  final painter = TextPainter(
                    text: TextSpan(text: widget.text, style: style),
                    textDirection: Directionality.of(context),
                    maxLines: 1,
                  )..layout();
                  final textWidth = painter.width;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _measured(box.maxWidth, textWidth);
                  });
                  if (still) {
                    return Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        widget.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: style,
                      ),
                    );
                  }
                  return ClipRect(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_run, _shine]),
                      builder: (context, _) {
                        final x = lerpDouble(
                          box.maxWidth,
                          -textWidth,
                          _run.value,
                        )!;
                        final s = _shine.value * 1.5 - 0.25;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: x,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (rect) => LinearGradient(
                                    colors: [
                                      brand.onPrimary.withValues(alpha: 0.8),
                                      brand.onPrimary,
                                      brand.onPrimary.withValues(alpha: 0.8),
                                    ],
                                    stops: [
                                      (s - 0.2).clamp(0.0, 1.0),
                                      s.clamp(0.0, 1.0),
                                      (s + 0.2).clamp(0.0, 1.0),
                                    ],
                                  ).createShader(rect),
                                  child: Text(
                                    widget.text,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: style,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            if (widget.onStop != null)
              IconButton(
                tooltip: context.l10n.announceStop,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.close,
                  size: AppIconSize.md,
                  color: brand.onPrimary,
                ),
                onPressed: widget.onStop,
              )
            else
              const SizedBox(width: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

/// The megaphone: it swings and swells as if ringing, with a soft wave
/// spreading from it, then rests a moment before ringing again.
class _RingingMegaphone extends StatelessWidget {
  const _RingingMegaphone({
    required this.animation,
    required this.color,
    required this.still,
  });

  final Animation<double> animation;
  final Color color;
  final bool still;

  static const _box = 34.0;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(Icons.campaign, size: AppIconSize.lg, color: color);
    if (still) return SizedBox(width: _box, height: _box, child: icon);
    return SizedBox(
      width: _box,
      height: _box,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = animation.value;
          // Rings during the first 60% of the cycle, then rests.
          final ring = (t / 0.6).clamp(0.0, 1.0);
          final swing = t < 0.6
              ? math.sin(ring * 6 * math.pi) * 0.3 * (1 - ring)
              : 0.0;
          final swell = t < 0.6 ? 1 + 0.18 * math.sin(ring * math.pi) : 1.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - t) * 0.35,
                child: Container(
                  width: _box * (0.5 + 0.5 * t),
                  height: _box * (0.5 + 0.5 * t),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                ),
              ),
              Transform.rotate(
                angle: swing,
                child: Transform.scale(scale: swell, child: icon),
              ),
            ],
          );
        },
      ),
    );
  }
}
