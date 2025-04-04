import 'package:flutter/material.dart';
import 'package:frontend/src/features/freezer_management/freezer_desktop.dart';
import 'package:frontend/src/features/freezer_management/freezer_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';

class Freezer extends StatefulWidget {
  const Freezer({super.key});

  @override
  State<Freezer> createState() => _FreezerState();
}

class _FreezerState extends State<Freezer> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: FreezerDesktop(),
      mobileLayout: FreezerMobile(),
    );
  }
}
