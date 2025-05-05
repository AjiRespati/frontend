import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/stock_desktop.dart';
import 'package:frontend/src/features/stock/stock_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isClient = (get<SystemViewModel>().level ?? 0) < 4;
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
      var user = get<SystemViewModel>().user;
      var userClient = (user?['levelDesc'] ?? "salesman")
          .toLowerCase()
          .replaceAll(" ", "");
      get<StockViewModel>().getStockTable(
        context: context,
        status: 'created',
        isClient: isClient,
        salesId:
            isClient
                ? userClient == "salesman"
                    ? get<SystemViewModel>().salesId
                    : null
                : null,
        subAgentId:
            isClient
                ? userClient == "subagent"
                    ? get<SystemViewModel>().subAgentId
                    : null
                : null,
        agentId:
            isClient
                ? userClient == "agent"
                    ? get<SystemViewModel>().agentId
                    : null
                : null,
        stockEvent: null,
      );
      get<StockViewModel>().getStockTable(
        context: context,
        status: 'settled',
        isClient: isClient,
        salesId:
            isClient
                ? userClient == "salesman"
                    ? get<SystemViewModel>().salesId
                    : null
                : null,
        subAgentId:
            isClient
                ? userClient == "subagent"
                    ? get<SystemViewModel>().subAgentId
                    : null
                : null,
        agentId:
            isClient
                ? userClient == "agent"
                    ? get<SystemViewModel>().agentId
                    : null
                : null,
        stockEvent: null,
      );
      get<StockViewModel>().getStockTable(
        context: context,
        status: 'canceled',
        isClient: isClient,
        salesId:
            isClient
                ? userClient == "salesman"
                    ? get<SystemViewModel>().salesId
                    : null
                : null,
        subAgentId:
            isClient
                ? userClient == "subagent"
                    ? get<SystemViewModel>().subAgentId
                    : null
                : null,
        agentId:
            isClient
                ? userClient == "agent"
                    ? get<SystemViewModel>().agentId
                    : null
                : null,
        stockEvent: null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: StockMobile(),
      desktopLayout: StockDesktop(),
    );
  }
}
