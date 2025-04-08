// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/dashboard_desktop.dart';
import 'package:frontend/src/features/dashboard/dashboard_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Dashboard extends StatefulWidget with GetItStatefulWidgetMixin {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with GetItStateMixin {
  Future<void> _setup() async {
    await get<SystemViewModel>().self(context);
    var user = get<SystemViewModel>().user;
    get<StockViewModel>().client =
        (user['levelDesc'] ?? "salesman").toLowerCase();

    get<StockViewModel>().salesId = get<SystemViewModel>().salesId;
    get<StockViewModel>().subAgentId = get<SystemViewModel>().subAgentId;
    get<StockViewModel>().agentId = get<SystemViewModel>().agentId;

    get<StockViewModel>().fetchCommissionData(context: context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: DashboardMobile(),
      desktopLayout: DashboardDesktop(),
    );
  }
}
