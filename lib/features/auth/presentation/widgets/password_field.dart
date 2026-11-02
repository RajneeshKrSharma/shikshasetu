import 'package:flutter/material.dart';

/// Password input with a show/hide toggle.
///
/// The toggle is purely visual, so it lives in a [ValueNotifier] owned by
/// this widget's [State] (created in initState, released in dispose).
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.textInputAction,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late final ValueNotifier<bool> _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(true);
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscure,
      builder: (context, obscure, _) => TextFormField(
        controller: widget.controller,
        obscureText: obscure,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        onFieldSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => _obscure.value = !obscure,
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
