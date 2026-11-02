import '../../../../core/theme/app_colors.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../bloc/proof_cubit.dart';

/// A box to sign in with a finger. When the finger lifts, the drawing is
/// handed to the [ProofCubit] to be kept. Expects one above it.
class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key, required this.label, this.height = 120});

  final String label;
  final double height;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  /// The strokes drawn so far; purely visual, so a notifier holds them.
  late final ValueNotifier<List<List<Offset>>> _strokes;

  @override
  void initState() {
    super.initState();
    _strokes = ValueNotifier(const []);
  }

  @override
  void dispose() {
    _strokes.dispose();
    super.dispose();
  }

  Future<Uint8List> _png(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    _paintStrokes(canvas, _strokes.value, Colors.black);
    final image = await recorder.endRecording().toImage(
      size.width.round(),
      size.height.round(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  void _start(Offset p) => _strokes.value = [
    ..._strokes.value,
    [p],
  ];

  void _extend(Offset p) {
    final all = [..._strokes.value];
    all.last = [...all.last, p];
    _strokes.value = all;
  }

  Future<void> _end(Size size) async {
    final cubit = context.read<ProofCubit>();
    await cubit.signed(await _png(size));
  }

  void _clear() {
    _strokes.value = const [];
    context.read<ProofCubit>().clearSignature();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.label, style: context.text.labelLarge)),
            TextButton(onPressed: _clear, child: Text(l.proofClear)),
          ],
        ),
        LayoutBuilder(
          builder: (context, box) {
            final size = Size(box.maxWidth, widget.height);
            return GestureDetector(
              onPanStart: (d) => _start(d.localPosition),
              onPanUpdate: (d) => _extend(d.localPosition),
              onPanEnd: (_) => _end(size),
              child: Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(
                    color: context.brand.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          l.proofSignHere,
                          style: context.text.bodySmall!.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<List<List<Offset>>>(
                        valueListenable: _strokes,
                        builder: (context, strokes, _) => CustomPaint(
                          size: size,
                          painter: _StrokePainter(strokes),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

void _paintStrokes(Canvas canvas, List<List<Offset>> strokes, Color color) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
  for (final stroke in strokes) {
    if (stroke.length == 1) {
      canvas.drawPoints(ui.PointMode.points, stroke, paint);
      continue;
    }
    final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
    for (final p in stroke.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);
  }
}

class _StrokePainter extends CustomPainter {
  const _StrokePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) =>
      _paintStrokes(canvas, strokes, Colors.black);

  @override
  bool shouldRepaint(_StrokePainter old) => old.strokes != strokes;
}
