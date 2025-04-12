import 'package:flutter/material.dart';
import 'package:frontend/src/features/transactions/components/transaction_buy.dart';
import 'package:frontend/src/features/transactions/components/transaction_resume.dart';
import 'package:frontend/src/features/transactions/components/transaction_sell_client.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TransactionMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  TransactionMobile({super.key});

  @override
  State<TransactionMobile> createState() => _TransactionMobileState();
}

class _TransactionMobileState extends State<TransactionMobile>
    with GetItStateMixin, SingleTickerProviderStateMixin {
  late TabController _transactionTabController;
  int _level = 0;

  @override
  void initState() {
    super.initState();
    _transactionTabController = TabController(length: 2, vsync: this);
    _transactionTabController.addListener(() {
      // kalau index tidak berubah berarti swipe.
      if (!_transactionTabController.indexIsChanging) {
        get<StockViewModel>().stockTabIndex = _transactionTabController.index;
      }
    });
    _level = (get<SystemViewModel>().level ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_level < 4 ? "Pemesanan" : "Pembelian"),
        actions: [
          if (watchOnly((StockViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
        ],
        bottom:
            _level < 4
                ? null
                : TabBar(
                  labelColor: Colors.blue.shade800,
                  unselectedLabelColor: Colors.grey.shade600,
                  controller: _transactionTabController,
                  indicatorColor: Colors.blue.shade700,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 5,
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(icon: Icon(Icons.note_alt), text: "Resume"),
                    Tab(icon: Icon(Icons.sell_outlined), text: "Pembelian"),
                  ],
                ),
      ),
      body: TabBarView(
        controller: _transactionTabController,
        children: [
          TransactionResume(),
          _level < 4 ? TransactionSellClient() : TransactionBuy(),
        ],
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
