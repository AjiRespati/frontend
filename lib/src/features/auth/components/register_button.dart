// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({required this.handleRegister, super.key});

  final Function() handleRegister;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: GradientElevatedButton(
        // inactiveDelay: Duration.zero,
        onPressed: () async {
          handleRegister();
        },
        borderRadius: 15,
        child: const Text(
          "Register",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
