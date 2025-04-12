import 'package:flutter/material.dart';
import 'package:frontend/src/features/transactions/transaction_desktop.dart';
import 'package:frontend/src/features/transactions/transaction_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Transaction extends StatefulWidget with GetItStatefulWidgetMixin {
  Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> with GetItStateMixin {
  bool isClient = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClient = (get<SystemViewModel>().level ?? 0) < 4;
      if (!isClient) {
        get<StockViewModel>().getStockBatches(
          context: context,
          status: 'completed',
          sortBy: null,
          sortOrder: null,
          page: null,
          limit: null,
        );
      }
      get<StockViewModel>().fetchProducts(context);

      String? id =
          get<SystemViewModel>().salesId ??
          (get<SystemViewModel>().subAgentId ??
              (get<SystemViewModel>().agentId));

      String salesId = id ?? "";
      get<StockViewModel>().getShopsBySales(
        context: context,
        salesId: salesId,
        isActive: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: TransactionDesktop(),
      mobileLayout: TransactionMobile(),
    );
  }
}
