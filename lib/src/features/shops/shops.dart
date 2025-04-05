import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/shops_desktop.dart';
import 'package:frontend/src/features/shops/shops_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Shops extends StatefulWidget with GetItStatefulWidgetMixin {
  Shops({super.key});

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String salesId = get<SystemViewModel>().salesId ?? "";
      get<StockViewModel>().getShopsBySales(context: context, salesId: salesId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: ShopsDesktop(),
      mobileLayout: ShopsMobile(),
    );
  }
}
