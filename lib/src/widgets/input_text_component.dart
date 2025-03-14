import 'package:flutter/material.dart';

class InputTextComponent extends StatefulWidget {
  const InputTextComponent({
    required this.hint,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.obscuring,
    required this.autofocus,
    required this.onChanged,
    required this.onEditingComplete,
    required super.key,
  });

  final String hint;
  final bool obscuring;
  final bool autofocus;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function()? onEditingComplete;
  @override
  State<InputTextComponent> createState() => _InputTextComponentState();
}

class _InputTextComponentState extends State<InputTextComponent> {
  bool isObscure = false;

  handlePressed() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscuring;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        // fillColor: Colors.white,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : widget.obscuring
                ? IconButton(
                    onPressed: () {
                      handlePressed();
                    },
                    icon: isObscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  )
                : null,
      ),
      obscureText: isObscure,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      // autovalidateMode:
      //     widget.hint == "Email" ? AutovalidateMode.onUserInteraction : null,
      // validator: (email) => email != null && !EmailValidator.validate(email)
      //     ? "Please enter a valid email"
      //     : null,
    );
  }
}
