import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/shops_desktop.dart';
import 'package:frontend/src/features/shops/shops_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Shops extends StatefulWidget with GetItStatefulWidgetMixin {
  Shops({required this.isAllShop, super.key});
  final bool? isAllShop;

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isAllShop != true) {
        String? id =
            get<SystemViewModel>().salesId ??
            (get<SystemViewModel>().subAgentId ??
                (get<SystemViewModel>().agentId));

        String clientId = id ?? "";
        get<StockViewModel>().getShopsBySales(
          // context: context,
          clientId: clientId,
        );
      }
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
