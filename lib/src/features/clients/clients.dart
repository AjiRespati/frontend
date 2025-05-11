// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/clients_desktop.dart';
import 'package:frontend/src/features/clients/clients_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Clients extends StatefulWidget with GetItStatefulWidgetMixin {
  Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> with GetItStateMixin {
  Future<void> _setup() async {
    await get<SystemViewModel>().self(context);
    get<StockViewModel>().fetchSalesmen(isInitial: true, status: 'active');
    get<StockViewModel>().fetchSubAgents(
      context: context,
      isInitial: true,
      status: 'active',
    );
    get<StockViewModel>().fetchAgents(
      context: context,
      isInitial: true,
      status: 'active',
    );
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
      mobileLayout: ClientsMobile(),
      desktopLayout: ClientsDesktop(),
    );
  }
}
