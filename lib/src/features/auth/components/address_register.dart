import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressRegister extends StatelessWidget with GetItMixin {
  AddressRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: get<SystemViewModel>().usernameController,
      decoration: InputDecoration(
        label: Text("Address", style: GoogleFonts.inter(fontSize: 12)),
        hintText: "Address",
        hintStyle: GoogleFonts.inter(fontSize: 12),
        prefixIcon: const Icon(Icons.person_rounded, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Address can't be empty";
        }

        return null;
      },
      autofocus: true,
    );
  }
}
