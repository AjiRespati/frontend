import 'package:flutter/material.dart';
import 'package:frontend/src/features/freezer/freezer_desktop.dart';
import 'package:frontend/src/features/freezer/freezer_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Freezer extends StatefulWidget with GetItStatefulWidgetMixin {
  Freezer({super.key});

  @override
  State<Freezer> createState() => _FreezerState();
}

class _FreezerState extends State<Freezer> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // get<StockViewModel>().getAllFrezer(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: FreezerDesktop(),
      mobileLayout: FreezerMobile(),
    );
  }
}
