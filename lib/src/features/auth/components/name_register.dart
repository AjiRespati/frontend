import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class NameRegister extends StatelessWidget with GetItMixin {
  NameRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: get<SystemViewModel>().nameController,
      decoration: InputDecoration(
        label: Text("Name", style: GoogleFonts.inter(fontSize: 12)),
        hintText: "Name",
        hintStyle: GoogleFonts.inter(fontSize: 12),
        prefixIcon: const Icon(Icons.person_rounded, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name can't be empty";
        }

        return null;
      },
      autofocus: true,
    );
  }
}
