import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/stock_desktop.dart';
import 'package:frontend/src/features/stock/stock_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Stock extends StatefulWidget with GetItStatefulWidgetMixin {
  Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    get<StockViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: StockMobile(),
      desktopLayout: StockDesktop(),
    );
  }
}
