import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_processed_view.dart';
import 'package:frontend/src/features/stock/components/stock_settled_view.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  StockMobile({super.key});

  @override
  State<StockMobile> createState() => _StockMobileState();
}

class _StockMobileState extends State<StockMobile>
    with SingleTickerProviderStateMixin, GetItStateMixin {
  late TabController _stockTabController;

  @override
  void initState() {
    super.initState();
    _stockTabController = TabController(length: 2, vsync: this);
    _stockTabController.addListener(() {
      // kalau index tidak berubah berarti swipe.
      if (!_stockTabController.indexIsChanging) {
        get<StockViewModel>().stockTabIndex = _stockTabController.index;
      }
    });
  }

  @override
  void dispose() {
    _stockTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.dateFromFilter);
    watchOnly((StockViewModel x) => x.dateToFilter);
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock"),
        actions: [
          (watchOnly((StockViewModel x) => x.isBusy))
              ? SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              )
              : SizedBox(),
          SizedBox(width: 20),
        ],
        bottom: TabBar(
          controller: _stockTabController,
          tabs: [
            Tab(icon: Icon(Icons.work_history_outlined), text: "Processing"),
            Tab(icon: Icon(Icons.check), text: "Settled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _stockTabController,
        children: [StockProcessedView(), StockSettledView()],
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
