// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginContent extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> with GetItStateMixin {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ApplicationInfo.appName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.w600,
                decorationColor: Colors.red,
                decorationThickness: 1.5,
              ),
            ),
          ],
        ),
        Text(ApplicationInfo.appVersion, style: TextStyle(fontSize: 12)),
        const SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: username,
          decoration: InputDecoration(
            label: Text("Email"),
            hintText: "Email",
            prefixIcon: const Icon(Icons.person_rounded, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            isDense: true,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email can't be empty";
            }

            return null;
          },
          autofocus: true,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: password,
          obscureText: !showPassword,
          decoration: InputDecoration(
            hintText: "Password",
            label: Text("Password"),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: const Icon(Icons.lock, size: 20),
            suffixIcon: IconButton(
              splashRadius: 20,
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
            isDense: true,
          ),
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password can't be empty";
            }

            return null;
          },
        ),
        const SizedBox(height: 20),
        // SizedBox(
        //   width: double.infinity,
        //   height: 44,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       elevation: 10, // Shadow elevation
        //       shadowColor: Colors.grey, // Shadow color
        //       backgroundColor: Color.fromRGBO(30, 48, 241, 1),
        //       foregroundColor: Colors.white,
        //       iconColor: Colors.white, // Icon color
        //     ),
        //     onPressed: () async {
        //       SystemViewModel model = get<SystemViewModel>();
        //       model.isBusy = true;
        //       var user = await ApiService().login(username.text, password.text);

        //       if (user != null) {
        //         model.isBusy = false;

        //         model.name = user?['name'];
        //         model.username = user?['username'];
        //         model.email = user?['email'];
        //         model.phone = user?['phone'];
        //         model.address = user?['address'];
        //         model.level = user?['level'];
        //         model.salesId = user?['salesId'];
        //         model.subAgentId = user?['subAgentId'];
        //         model.agentId = user?['agentId'];

        //         await Future.delayed(Durations.medium2);
        //         Navigator.pushReplacementNamed(context, dashboardRoute);
        //       } else {
        //         model.isBusy = false;
        //         if (mounted) {
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(
        //               showCloseIcon: true,
        //               backgroundColor: Colors.red.shade400,
        //               content: Text(
        //                 "Email atau password salah",
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             ),
        //           );
        //         }
        //       }
        //     },
        //     child: const Text(
        //       "Login",
        //       style: TextStyle(fontSize: 16, color: Colors.white),
        //     ),
        //   ),
        // ),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: GradientElevatedButton(
            inactiveDelay: Duration.zero,
            onPressed: () async {
              SystemViewModel model = get<SystemViewModel>();
              model.isBusy = true;
              var user = await ApiService().login(username.text, password.text);

              if (user != null) {
                model.isBusy = false;

                model.name = user?['name'];
                model.username = user?['username'];
                model.email = user?['email'];
                model.phone = user?['phone'];
                model.address = user?['address'];
                model.level = user?['level'];
                model.salesId = user?['salesId'];
                model.subAgentId = user?['subAgentId'];
                model.agentId = user?['agentId'];

                await Future.delayed(Durations.medium2);
                Navigator.pushReplacementNamed(context, dashboardRoute);
              } else {
                model.isBusy = false;
                if (mounted) {
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
              }
            },
            borderRadius: 15,
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
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
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.red,
                  decorationThickness: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Center(child: Image.asset('assets/images/walls_logo.png', width: 150)),
        const SizedBox(height: 10),
        Text(
          "Bikin Semua Jadi Happy",
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.w700,
            decorationColor: Colors.red,
            decorationThickness: 1.5,
          ),
        ),
      ],
    );
  }
}
