import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/auth/components/login_button.dart';
import 'package:frontend/src/features/auth/components/login_password.dart';
import 'package:frontend/src/features/auth/components/login_title.dart';
import 'package:frontend/src/features/auth/components/login_username.dart';
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
            LoginPassword(),
            const SizedBox(height: 20),
            LoginButton(),
          ],
        );
  }
}
