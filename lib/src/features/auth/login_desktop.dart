import 'package:flutter/material.dart';
import 'package:frontend/src/features/auth/login_content.dart';

class LoginDesktop extends StatelessWidget {
  const LoginDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(width: 900),
          Column(
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: 600,
                  maxWidth: 350,
                ),
                child: LoginContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
