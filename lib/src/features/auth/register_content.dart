// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/auth/components/confirm_password.dart';
import 'package:frontend/src/features/auth/components/email_register.dart';
import 'package:frontend/src/features/auth/components/login_password.dart';
import 'package:frontend/src/features/auth/components/login_title.dart';
import 'package:frontend/src/features/auth/components/name_register.dart';
import 'package:frontend/src/features/auth/components/phone_register.dart';
import 'package:frontend/src/features/auth/components/register_button.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RegisterContent extends StatelessWidget with GetItMixin {
  RegisterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return watchOnly((SystemViewModel x) => x.isBusy)
        ? const Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        )
        : SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const LoginTitle(title: "Register ${ApplicationInfo.appName}"),
              Text(ApplicationInfo.appVersion),
              const SizedBox(height: 20),
              EmailRegister(),
              const SizedBox(height: 20),
              LoginPassword(),
              const SizedBox(height: 20),
              ConfirmPassword(),
              const SizedBox(height: 20),
              NameRegister(),
              const SizedBox(height: 20),
              PhoneRegister(),
              const SizedBox(height: 20),
              RegisterButton(
                handleRegister: () async {
                  bool isRegistered = await get<SystemViewModel>().register();

                  if (isRegistered) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Registrasi sukses"),
                        duration: Duration(
                          seconds: 3,
                        ), // Adjust duration as needed
                      ),
                    );
                    get<SystemViewModel>().passwordController.text = "";
                    await Future.delayed(Durations.medium1);
                    get<SystemViewModel>().isLoginView = true;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        showCloseIcon: true,
                        backgroundColor: Colors.red.shade400,
                        content: Text(
                          "Registrasi gagal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      get<SystemViewModel>().isLoginView = true;
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}
