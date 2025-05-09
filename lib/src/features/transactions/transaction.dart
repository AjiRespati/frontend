// ignore_for_file: use_build_context_synchronously

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

  Future<void> _setup() async {
    await get<SystemViewModel>().self(context);
    isClient =
        (get<SystemViewModel>().level ?? 0) < 4 ||
        (get<SystemViewModel>().level ?? 0) > 5;
    DateTime dateFromFilter = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );
    DateTime dateToFilter = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      1,
    ).subtract(Duration(days: 1));
    get<StockViewModel>().dateFromFilter = dateFromFilter;
    get<StockViewModel>().dateToFilter = dateToFilter;

    get<StockViewModel>().createdBy = get<SystemViewModel>().email;

    await get<StockViewModel>().getStockBatches(
      context: context,
      isClient: isClient,
      status: 'all',
      level: get<SystemViewModel>().level,
      shopId: get<SystemViewModel>().shopId,
      parentId: get<SystemViewModel>().shopParentId,
      parentType: get<SystemViewModel>().shopParentType,
      sortBy: null,
      sortOrder: null,
      page: null,
      limit: null,
    );

    get<StockViewModel>().fetchProducts(context);

    String? id =
        get<SystemViewModel>().salesId ??
        (get<SystemViewModel>().subAgentId ?? (get<SystemViewModel>().agentId));

    String clientId = id ?? "";
    get<StockViewModel>().getShopsBySales(
      // context: context,
      clientId: clientId,
      isActive: true,
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
    print(get<SystemViewModel>().shopParentId);
    print(get<SystemViewModel>().shopParentType);
    return ResponsiveLayout(
      desktopLayout: TransactionDesktop(),
      mobileLayout: TransactionMobile(),
    );
  }
}
