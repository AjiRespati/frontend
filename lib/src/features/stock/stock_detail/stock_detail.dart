import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/stock_detail/stock_detail_desktop.dart';
import 'package:frontend/src/features/stock/stock_detail/stock_detail_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockDetail extends StatefulWidget with GetItStatefulWidgetMixin {
  StockDetail({super.key});

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> with GetItStateMixin {
  _setup() async {
    // get<StockViewModel>().fetchProduct(widget.stockId);
    // get<StockViewModel>().fetchStockByProduct(widget.productId);
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
      desktopLayout: StockDetailDesktop(),
      mobileLayout: StockDetailMobile(),
    );
  }
}
