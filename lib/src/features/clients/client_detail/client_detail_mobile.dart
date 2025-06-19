// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/components/client_detail_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientDetailMobile extends StatelessWidget with GetItMixin {
  ClientDetailMobile({required this.item, required this.level, super.key});
  final dynamic item;
  final int level;

  @override
  Widget build(BuildContext context) {
    var mainItem = get<StockViewModel>().stockResume;
    var mainList =
        level == 1
            ? get<StockViewModel>().salesStockTable
            : level == 2
            ? get<StockViewModel>().subAgentStockTable
            : level == 3
            ? get<StockViewModel>().agentStockTable
            : get<StockViewModel>().agentStockTable;
    print("HMMMMM null kah...???");
    print(mainItem);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Client Detail"),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Flexible(
                  child: Text(
                    item['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[900],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text('Total penjualan: '),
                Text(formatCurrency(_generateTotalPrice(mainList, level))),
                // Text(formatCurrency(mainItem['totalNetPriceSum'])),
              ],
            ),
            Row(
              children: [
                Text('Total item terjual: '),
                Text((mainItem?['totalAmount'] ?? 0).toString()),
              ],
            ),
            Row(
              children: [
                Text('Total komisi: '),
                Text(
                  formatCurrency(
                    _generateTotalKomisi(mainItem, level).toDouble(),
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Text('Total komisi toko: '),
            //     Text(formatCurrency(mainItem['totalShopAllCommission'])),
            //   ],
            // ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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

                  SizedBox(
                    // width: 40,
                    child: GradientElevatedButton(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      buttonHeight: 34,
                      onPressed: () async {
                        await get<StockViewModel>().getStockResume(
                          context: context,
                          salesId: item['id'],
                          agentId: null,
                          shopId: null,
                          subAgentId: null,
                        );
                        await get<StockViewModel>().getTableBySalesId(
                          context: context,
                          salesId: item['id'],
                        );
                      },
                      child: Icon(Icons.search, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 175,
                  child: ListView.builder(
                    itemCount: mainList.length,
                    itemBuilder: (context, index) {
                      var item = mainList[index];
                      return ClientDetailCard(
                        item: item,
                        key: ValueKey(index + 1000),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return SizedBox(
      height: 32,
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
          style: TextStyle(fontSize: 13),
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
      case 6:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['shopPrice'] ?? 0)),
        );
      default:
        totalPrice;
    }

    return totalPrice;
  }

  double _generateTotalKomisi(dynamic mainItem, int level) {
    double totalKomisi = 0;
    if (mainItem != null) {
      switch (level) {
        case 5:
          totalKomisi.toDouble();
          break;
        case 4:
          totalKomisi.toDouble();
          break;
        case 3:
          totalKomisi = mainItem['totalAgentCommission'].toDouble();
          break;
        case 2:
          totalKomisi = mainItem['totalSubAgentCommission'].toDouble();
          break;
        case 1:
          totalKomisi = mainItem['totalSalesmanCommission'].toDouble();
          break;
        case 6:
          totalKomisi = mainItem['totalShopCommission'].toDouble();
          break;
        default:
          totalKomisi;
      }
    }
    return totalKomisi.toDouble();
  }
}
