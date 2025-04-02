import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_management/user_management_desktop.dart';
import 'package:frontend/src/features/user_management/user_management_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: UserManagementDesktop(),
      mobileLayout: UserManagementMobile(),
    );
  }
}
