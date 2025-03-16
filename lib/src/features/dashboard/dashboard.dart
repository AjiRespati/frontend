import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/dashboard_desktop.dart';
import 'package:frontend/src/features/dashboard/dashboard_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Dashboard extends StatefulWidget with GetItStatefulWidgetMixin {
  Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    get<StockViewModel>().fetchCommissionData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: DashboardMobile(),
      desktopLayout: DashboardDesktop(),
    );
  }
}
