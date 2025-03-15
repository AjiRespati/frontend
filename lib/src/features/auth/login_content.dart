import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/src/application_info.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationInfo.appName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: get<SystemViewModel>().usernameController,
              decoration: InputDecoration(
                label: Text("Username", style: GoogleFonts.inter(fontSize: 12)),
                hintText: "Username",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                prefixIcon: const Icon(Icons.person_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username can't be empty";
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: get<SystemViewModel>().passwordController,
              obscureText: !get<SystemViewModel>().showPassword,
              onEditingComplete: () {
                get<SystemViewModel>().onLogin(context: context);
              },
              onTap: () {
                log('tapped');
              },
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: GoogleFonts.inter(fontSize: 12),
                label: Text("Password", style: GoogleFonts.inter(fontSize: 12)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password can't be empty";
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3487a5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  get<SystemViewModel>().onLogin(context: context);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );
  }
}
