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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<StockViewModel>().fetchProducts(context);
      var user = get<SystemViewModel>().user;
      get<StockViewModel>().client =
          (user['levelDesc'] ?? "salesman").toLowerCase();

      get<StockViewModel>().salesId = get<SystemViewModel>().salesId;
      get<StockViewModel>().subAgentId = get<SystemViewModel>().subAgentId;
      get<StockViewModel>().agentId = get<SystemViewModel>().agentId;

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
