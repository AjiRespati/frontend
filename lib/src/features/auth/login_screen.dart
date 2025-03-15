import 'package:flutter/material.dart';
import 'package:frontend/src/features/auth/login_desktop.dart';
import 'package:frontend/src/features/auth/login_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    get<SystemViewModel>().checkSession(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    get<SystemViewModel>().usernameController.dispose();
    get<SystemViewModel>().passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: LoginDesktop(),
      mobileLayout: LoginMobile(),
    );
  }
}
