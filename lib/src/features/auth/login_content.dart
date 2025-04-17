// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/auth/components/login_button.dart';
import 'package:frontend/src/features/auth/components/login_password.dart';
import 'package:frontend/src/features/auth/components/login_title.dart';
import 'package:frontend/src/features/auth/components/login_username.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginContent extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const LoginTitle(title: ApplicationInfo.appName),
        Text(ApplicationInfo.appVersion),
        const SizedBox(height: 20),
        LoginUsername(),
        const SizedBox(height: 20),
        LoginPassword(
          handleLogin: () async {
            bool isLogin = await get<SystemViewModel>().onLogin();
            if (isLogin) {
              get<SystemViewModel>().isBusy = false;
              await Future.delayed(Durations.medium2);
              Navigator.pushReplacementNamed(context, dashboardRoute);
            } else {
              get<SystemViewModel>().isBusy = false;
              // await Future.delayed(Durations.medium2);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    backgroundColor: Colors.red.shade400,
                    content: Text(
                      "Email atau password salah",
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: 20),
        LoginButton(
          handleLogin: () async {
            bool isLogin = await get<SystemViewModel>().onLogin();
            if (isLogin) {
              get<SystemViewModel>().isBusy = false;
              await Future.delayed(Durations.medium2);
              Navigator.pushReplacementNamed(context, dashboardRoute);
            } else {
              get<SystemViewModel>().isBusy = false;
              await Future.delayed(Durations.medium2);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  showCloseIcon: true,
                  backgroundColor: Colors.red.shade400,
                  content: Text(
                    "Email atau password salah",
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
                get<SystemViewModel>().isLoginView = false;
              },
              child: Text(
                "Register",
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
    );
  }
}
