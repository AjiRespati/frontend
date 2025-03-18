import 'package:flutter/material.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
