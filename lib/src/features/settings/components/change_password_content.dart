// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordContent extends StatefulWidget
    with GetItStatefulWidgetMixin {
  ChangePasswordContent({required this.username, super.key});

  final String username;

  @override
  State<ChangePasswordContent> createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<ChangePasswordContent>
    with GetItStateMixin {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool showPassword = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ganti Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.username,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 40),

          TextFormField(
            controller: passwordController,
            obscureText: !showPassword,
            onTap: () {},
            decoration: InputDecoration(
              hintText: "Password Baru",
              hintStyle: GoogleFonts.inter(fontSize: 12),
              label: Text(
                "Password baru",
                style: GoogleFonts.inter(fontSize: 12),
              ),
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
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
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
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: confirmpasswordController,
            obscureText: !showPassword,
            onTap: () {},
            decoration: InputDecoration(
              hintText: "Konfirmasi Password",
              hintStyle: GoogleFonts.inter(fontSize: 12),
              label: Text(
                "Konfirmasi Password",
                style: GoogleFonts.inter(fontSize: 12),
              ),
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
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm Password can't be empty";
              } else if (passwordController.text != value) {
                return "Confirm password not match.";
              }

              return null;
            },
          ),
          SizedBox(height: 50),
          Text(
            errorMessage.isNotEmpty
                ? errorMessage
                : "Ingatlah password baru anda!",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color:
                  errorMessage.isNotEmpty
                      ? Colors.red.shade600
                      : Colors.amber.shade900,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30),
          GradientElevatedButton(
            onPressed: () async {
              var resp = await get<SystemViewModel>().changePassword(
                newPassword: passwordController.text,
              );

              if (resp) {
                Navigator.pop(context, true);
              } else {
                setState(() {
                  errorMessage = "Ganti password gagal";
                });
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  errorMessage = "";
                });
              }
            },
            child: Text("Ganti Password"),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
