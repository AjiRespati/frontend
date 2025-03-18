import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/clients_desktop.dart';
import 'package:frontend/src/features/clients/clients_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Clients extends StatefulWidget with GetItStatefulWidgetMixin {
  Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<StockViewModel>().fetchSalesmen();
      get<StockViewModel>().fetchSubAgents();
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
