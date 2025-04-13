// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/canceling_stock.dart';
import 'package:frontend/src/features/transactions/components/resume_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TransactionResume extends StatefulWidget with GetItStatefulWidgetMixin {
  TransactionResume({super.key});

  @override
  State<TransactionResume> createState() => _TransactionResumeState();
}

class _TransactionResumeState extends State<TransactionResume>
    with GetItStateMixin {
  String _messageSuccess = "";
  String _messageError = "";

  _handleBatchActions(Map<String, dynamic> stock, double totalPrice) async {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(minHeight: 600, maxHeight: 620),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Konfirmasi Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Apakah pembayaran senilai: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  formatCurrency(totalPrice),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
              Text(
                "Telah dilakukan?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Pastikan pembayaran telah dilakukan!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: GradientElevatedButton(
                      // inactiveDelay: Duration.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.close, color: Colors.white, size: 20),
                          Text(
                            "Tidak",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 120,
                    child: GradientElevatedButton(
                      inactiveDelay: Durations.short1,
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onPressed: () async {
                        bool? result = await get<StockViewModel>()
                            .settleStockBatch(batchId: stock['id']);

                        if (result == true) {
                          await get<StockViewModel>().getStockBatches(
                            context: context,
                            status: 'completed',
                            sortBy: null,
                            sortOrder: null,
                            page: null,
                            limit: null,
                          );
                          _messageSuccess = "Konfirmasi pembayaran berhasil.";
                          _messageError = "";
                          get<StockViewModel>().reloadBuy = false;
                          get<StockViewModel>().isBusy = false;
                          get<StockViewModel>().reloadBuy = null;
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     showCloseIcon: true,
                          //     backgroundColor: Colors.green.shade400,
                          //     content: Text(
                          //       "Konfirmasi pembayaran berhasil.",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     duration: Duration(seconds: 2),
                          //   ),
                          // );
                        } else {
                          _messageSuccess = "";
                          _messageError =
                              "Konfirmasi pembayaran gagal, hubungi pengembang aplikasi";
                          get<StockViewModel>().reloadBuy = false;
                          get<StockViewModel>().isBusy = false;
                          get<StockViewModel>().reloadBuy = null;
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     showCloseIcon: true,
                          //     backgroundColor: Colors.red.shade400,
                          //     content: Text(
                          //       "Konfirmasi pembayaran gagal, hubungi pengembang aplikasi",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     duration: Duration(seconds: 2),
                          //   ),
                          // );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          // SizedBox(width: 5),
                          Text(
                            "Ya",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 220,
                  child: GradientElevatedButton(
                    // inactiveDelay: Duration.zero,
                    gradient: LinearGradient(
                      colors: [Colors.red.shade300, Colors.red.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          minHeight: 600,
                          maxHeight: 620,
                        ),
                        context: context,
                        builder: (context) {
                          return CancelingStock(item: stock, isBatch: true);
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Batalkan ",
                          // _isFactory
                          //     ? "Batalkan Pembelian  "
                          //     : "Batalkan Penjualan  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // bool isClient = (get<SystemViewModel>().level ?? 0) < 4;
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.reloadBuy);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
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
                    // inactiveDelay: Duration.zero,
                    buttonHeight: 34,
                    onPressed: () {
                      get<StockViewModel>().getStockBatches(
                        context: context,
                        status: 'completed',
                        sortBy: null,
                        sortOrder: null,
                        page: null,
                        limit: null,
                      );
                    },
                    child: Icon(Icons.search, color: Colors.white, size: 30),
                  ),
                ],
              ),
              if (get<StockViewModel>().isBusy)
                Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
        watchOnly((StockViewModel x) => x.responseBatch).isEmpty
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
                    (MediaQuery.of(context).size.height - 280) -
                    (kIsWeb ? 0 : 50),
                child: ListView.builder(
                  itemCount: get<StockViewModel>().responseBatch.length,

                  itemBuilder: (context, index) {
                    int level = get<SystemViewModel>().level ?? 0;
                    Map<String, dynamic> stock =
                        get<StockViewModel>().responseBatch[index];
                    List<dynamic> stocks = stock['Stocks'];
                    double totalPrice = _generateTotalPrice(stocks, level);
                    int totalProduct = _generateTotalProduct(stocks);
                    int totalItem = _generateTotalItem(stocks);

                    print(stock);

                    return ResumeCard(
                      stock: stock,
                      totalProduct: totalProduct,
                      totalItem: totalItem,
                      totalPrice: totalPrice,
                      stocks: stocks,
                      onSelect: () {
                        _handleBatchActions(stock, totalPrice);
                      },
                    );
                  },
                ),
              ),
            ),
      ],
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

  double _generateTotalPrice(List<dynamic> stocks, int level) {
    double totalPrice = 0;
    switch (level) {
      case 5:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['totalPrice'] ?? 0)),
        );
        break;
      case 4:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['totalPrice'] ?? 0)),
        );
        break;
      case 3:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['agentPrice'] ?? 0)),
        );
        break;
      case 2:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['subAgentPrice'] ?? 0)),
        );
        break;
      case 1:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['salesmanPrice'] ?? 0)),
        );
        break;
      default:
    }

    return totalPrice;
  }

  int _generateTotalProduct(List<dynamic> stocks) {
    return stocks.length;
  }

  int _generateTotalItem(List<dynamic> stocks) {
    return stocks.fold<int>(
      0,
      (sum, item) => sum + ((item['amount'] ?? 0) as int),
    );
  }
}
