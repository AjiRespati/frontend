// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RegisterButton extends StatelessWidget with GetItMixin {
  RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: GradientElevatedButton(
        inactiveDelay: Duration.zero,
        onPressed: () async {
          await get<SystemViewModel>().register();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Register Success"),
            ),
          );
          get<SystemViewModel>().passwordController.text = "";
          get<SystemViewModel>().isLoginView = true;
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
