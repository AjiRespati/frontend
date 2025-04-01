import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientDetailMobile extends StatelessWidget with GetItMixin {
  ClientDetailMobile({required this.item, super.key});
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    var mainItem = get<StockViewModel>().stockResume;
    var mainList = get<StockViewModel>().salesStockTable;
    return Scaffold(
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
                Text(formatCurrency(mainItem['totalNetPriceSum'])),
              ],
            ),
            Row(
              children: [
                Text('Total item terjual: '),
                Text(mainItem['totalAmount'].toString()),
              ],
            ),
            Row(
              children: [
                Text('Total komisi: '),
                Text(formatCurrency(mainItem['totalSalesmanCommission'])),
              ],
            ),
            Row(
              children: [
                Text('Total komisi toko: '),
                Text(formatCurrency(mainItem['totalShopAllCommission'])),
              ],
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
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(item['productName']),
                              Text("(${item['metricType']})"),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['status']),
                                        Text(
                                          formatDateString(item['updatedAt']),
                                        ),
                                        Text(item['amount'].toString()),
                                        Text(formatCurrency(item['netPrice'])),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatCurrency(item['totalNetPrice']),
                                        ),
                                        Text(
                                          formatCurrency(
                                            item['salesmanCommission'] ?? 0,
                                          ),
                                        ),
                                        Text(
                                          formatCurrency(
                                            item['shopAllCommission'] ?? 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
}
