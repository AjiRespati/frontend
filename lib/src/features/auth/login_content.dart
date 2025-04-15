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

class LoginContent extends StatelessWidget with GetItMixin {
  LoginContent({super.key});

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
        : Column(
          children: [
            const SizedBox(height: 20),
            const LoginTitle(title: ApplicationInfo.appName),
            const SizedBox(height: 20),
            LoginUsername(),
            const SizedBox(height: 20),
            LoginPassword(
              handleLogin: () async {
                bool isLogin = await get<SystemViewModel>().onLogin();
                if (isLogin) {
                  get<SystemViewModel>().isBusy = false;
                  Navigator.pushReplacementNamed(context, dashboardRoute);
                } else {
                  get<SystemViewModel>().isBusy = false;

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
            const SizedBox(height: 20),
            LoginButton(
              handleLogin: () async {
                bool isLogin = await get<SystemViewModel>().onLogin();
                if (isLogin) {
                  get<SystemViewModel>().isBusy = false;
                  Navigator.pushReplacementNamed(context, dashboardRoute);
                } else {
                  get<SystemViewModel>().isBusy = false;

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
