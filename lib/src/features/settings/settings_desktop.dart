import 'package:flutter/material.dart';
import 'package:frontend/src/widgets/page_container.dart';

class SettingsDesktop extends StatelessWidget {
  const SettingsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      setSidebarExpanding: true,
      showMenubutton: true,
      mainSection: Container(color: Colors.blueAccent),
    );
  }
}
