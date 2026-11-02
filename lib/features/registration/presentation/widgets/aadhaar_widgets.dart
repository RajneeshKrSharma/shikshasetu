import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/aadhaar.dart';
import '../../../../core/utils/context_ext.dart';

/// Formats digits as "1234 5678 9012" while typing.
class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = Aadhaar.digitsOnly(newValue.text);
    final capped = digits.length > 12 ? digits.substring(0, 12) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(capped[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Explains what is (not) kept about the Aadhaar number.
class AadhaarNote extends StatelessWidget {
  const AadhaarNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline,
          size: AppIconSize.sm,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            context.l10n.aadhaarHelper,
            style: context.text.labelSmall,
          ),
        ),
      ],
    );
  }
}
