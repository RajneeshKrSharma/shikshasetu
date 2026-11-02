import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';

/// A field that opens a picker (a date, a range) instead of a keyboard. It
/// looks exactly like the text fields around it: the label sits inside while
/// empty and moves up once there is a value.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.prefixIcon,
    this.suffixIcon = Icons.calendar_today_outlined,
    this.errorText,
    this.helperText,
  });

  final String label;
  final VoidCallback onTap;

  /// What was picked, or null when nothing is.
  final String? value;
  final IconData? prefixIcon;
  final IconData suffixIcon;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final empty = value == null || value!.isEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: InputDecorator(
        isEmpty: empty,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          suffixIcon: Icon(suffixIcon),
        ),
        child: empty ? null : Text(value!, style: context.text.bodyLarge),
      ),
    );
  }
}
