import 'package:flutter/material.dart';
import 'package:frontend/src/features/settings/settings_desktop.dart';
import 'package:frontend/src/features/settings/settings_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: SettingsMobile(),
      desktopLayout: SettingsDesktop(),
    );
  }
}
