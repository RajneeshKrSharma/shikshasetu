import 'package:flutter/material.dart';

import '../../../../core/utils/context_ext.dart';

/// A small label above a coloured amount.
class FeeAmount extends StatelessWidget {
  const FeeAmount({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.labelSmall),
        const SizedBox(height: 2),
        Text(value, style: context.text.headlineSmall!.copyWith(color: color)),
      ],
    );
  }
}
