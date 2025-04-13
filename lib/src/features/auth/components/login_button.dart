// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({required this.handleLogin, super.key});

  final Function() handleLogin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: GradientElevatedButton(
        inactiveDelay: Duration.zero,
        onPressed: () {
          handleLogin();
        },
        borderRadius: 15,
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
