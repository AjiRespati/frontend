import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailRegister extends StatelessWidget with GetItMixin {
  EmailRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: get<SystemViewModel>().emailController,
      decoration: InputDecoration(
        label: Text("Email", style: GoogleFonts.inter(fontSize: 12)),
        hintText: "Email",
        hintStyle: GoogleFonts.inter(fontSize: 12),
        prefixIcon: const Icon(Icons.person_rounded, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email can't be empty";
        } else if (!EmailValidator.validate(value)) {
          return "Invalid email format";
        }

        return null;
      },
      autofocus: true,
    );
  }
}
