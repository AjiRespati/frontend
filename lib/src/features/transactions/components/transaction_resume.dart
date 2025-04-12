import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_client_card.dart';
import 'package:frontend/src/features/stock/components/stock_table_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TransactionResume extends StatelessWidget with GetItMixin {
  TransactionResume({super.key});

  @override
  Widget build(BuildContext context) {
    bool isClient = (get<SystemViewModel>().level ?? 0) < 4;
    return Column(
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
                // inactiveDelay: Duration.zero,
                buttonHeight: 34,
                onPressed: () {
                  get<StockViewModel>().getStockTable(
                    context: context,
                    status: 'settled',
                    isClient: (get<SystemViewModel>().level ?? 0) < 4,
                    salesId: null,
                    agentId: null,
                    subAgentId: null,
                    stockEvent: null,
                  );
                },
                child: Icon(Icons.search, color: Colors.white, size: 30),
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
                    if (level > 3) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(stock['userDesc'] + ": "),
                                        SizedBox(width: 10),
                                        Text(stock['createdBy']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formatDateString(stock['createdAt']),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Total Product: $totalProduct"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Total Item: $totalItem"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Total Price: ${formatCurrency(totalPrice)}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: stocks.length,
                                  itemBuilder: (context, index) {
                                    var item = stocks[index];
                                    return Text(
                                      "${item['productName']} ${item['amount']} ${item['metricType']}",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      return StockTableCard(
                        key: ValueKey(index + 14000),
                        isMobile: true,
                        stock: stock,
                        stockStatus: 'settled',
                      );
                    } else {
                      return Card(
                        child: Column(
                          children: [Text(stock['Stocks']['name'])],
                        ),
                      );
                      return StockClientCard(
                        key: ValueKey(index + 15000),
                        stockStatus: 'settled',
                        isMobile: true,
                        stock: stock,
                      );
                    }
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
