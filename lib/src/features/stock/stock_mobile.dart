import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_canceled_view.dart';
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
    _stockTabController = TabController(length: 3, vsync: this);
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
        bottom: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          controller: _stockTabController,
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 5,
          tabs: [
            Tab(icon: Icon(Icons.check), text: "Settled"),
            Tab(
              icon: Badge.count(
                isLabelVisible:
                    watchOnly(
                      (StockViewModel x) => x.stockOnProgressTable,
                    ).isNotEmpty,
                textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                count:
                    watchOnly(
                      (StockViewModel x) => x.stockOnProgressTable,
                    ).length,
                child: Icon(Icons.history_rounded),
              ),
              text: "Processing",
            ),
            Tab(icon: Icon(Icons.cancel_outlined), text: "Canceled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _stockTabController,
        children: [
          StockSettledView(),
          StockProcessedView(),
          StockCanceledView(),
        ],
      ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100007)),
    );
  }
}
