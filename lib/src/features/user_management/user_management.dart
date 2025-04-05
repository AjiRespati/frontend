import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_management/user_management_desktop.dart';
import 'package:frontend/src/features/user_management/user_management_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserManagement extends StatefulWidget with GetItStatefulWidgetMixin {
  UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // get<SystemViewModel>().getAllUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: UserManagementDesktop(),
      mobileLayout: UserManagementMobile(),
    );
  }
}
