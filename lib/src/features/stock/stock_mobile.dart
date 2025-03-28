import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_table_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
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
        children: [
          Container(color: Colors.blueAccent),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDatePicker(
                      context,
                      "From: ",
                      get<StockViewModel>().dateFromFilter,
                      (date) {
                        get<StockViewModel>().dateFromFilter = date;
                      },
                    ),

                    _buildDatePicker(
                      context,
                      "To: ",
                      get<StockViewModel>().dateToFilter,
                      (date) {
                        get<StockViewModel>().dateToFilter = date;
                      },
                    ),
                    GradientElevatedButton(
                      inactiveDelay: Duration.zero,
                      buttonHeight: 34,
                      onPressed: () {
                        get<StockViewModel>().getStockTable();
                      },
                      child: Icon(Icons.search, color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
              watchOnly((StockViewModel x) => x.stockTable).isEmpty
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Text("Tidak ada stok pada tanggal dipilih."),
                      ),
                    ],
                  )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height:
                          (MediaQuery.of(context).size.height - 275) -
                          (kIsWeb ? 0 : 50),
                      child: ListView.builder(
                        itemCount: get<StockViewModel>().stockTable.length,

                        itemBuilder: (context, index) {
                          return StockTableCard(
                            isMobile: true,
                            stock: get<StockViewModel>().stockTable[index],
                          );
                        },
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: () async {
          // DateTime? pickedDate = await showDatePicker(
          //   context: context,
          //   initialDate: selectedDate ?? DateTime.now(),
          //   firstDate: DateTime(2000),
          //   lastDate: DateTime.now(),
          DateTime? pickedDate = await showCustomDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
          );
          // );
          if (pickedDate != null) onDateSelected(pickedDate);
        },
        child: Text(
          label + (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
        ),
      ),
    );
  }
}
