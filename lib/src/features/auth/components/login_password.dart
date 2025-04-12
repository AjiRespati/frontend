// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPassword extends StatelessWidget with GetItMixin {
  LoginPassword({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((SystemViewModel x) => x.showPassword);
    return TextFormField(
      controller: get<SystemViewModel>().passwordController,
      obscureText: !get<SystemViewModel>().showPassword,
      onEditingComplete: () async {
        bool isLogin = await get<SystemViewModel>().onLogin();

        if (isLogin) {
          Navigator.pushReplacementNamed(context, dashboardRoute);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
        }
      },
      onTap: () {
        log('tapped');
      },
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: GoogleFonts.inter(fontSize: 12),
        label: Text("Password", style: GoogleFonts.inter(fontSize: 12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        prefixIcon: const Icon(Icons.lock, size: 20),
        suffixIcon: IconButton(
          splashRadius: 20,
          icon: Icon(
            get<SystemViewModel>().showPassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            get<SystemViewModel>().showPassword =
                !get<SystemViewModel>().showPassword;
          },
        ),
      ),
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password can't be empty";
        }

        return null;
      },
    );
  }
}
