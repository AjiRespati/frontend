import 'package:flutter/material.dart';
import 'input_text_component.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.hint,
    required this.obscuring,
    this.autofocus,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.onChanged,
    required this.onEditingComplete,
    super.key,
  });

  final String hint;
  final bool obscuring;
  final bool? autofocus;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 2,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InputTextComponent(
            hint: hint,
            obscuring: obscuring,
            autofocus: autofocus ?? false,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            key: key,
          ),
        ),
      ),
    );
  }
}
