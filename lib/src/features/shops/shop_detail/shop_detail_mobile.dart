// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/components/client_detail_card.dart';
import 'package:frontend/src/features/shops/components/update_shop.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ShopDetailMobile extends StatelessWidget with GetItMixin {
  ShopDetailMobile({required this.item, super.key});

  final Map<String, dynamic> item;
  @override
  Widget build(BuildContext context) {
    var mainItem = watchOnly((StockViewModel x) => x.stockResume);
    var mainList = watchOnly((StockViewModel x) => x.shopStockTable);
    print("MAIN ITEM: ");
    print(mainItem);
    print("MAIN LIST: ");
    print(mainList);
    print("ITEM: ");
    print(item);
    return Scaffold(
      appBar: AppBar(title: Text("Detail Toko")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
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
                          fontSize: 18,
                          color: Colors.blue[900],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          constraints: BoxConstraints(maxHeight: 640),
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                child: UpdateShop(shop: item),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(Icons.edit),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Total penjualan: '),
                          Text(
                            formatCurrency(mainItem?['totalNetPriceSum'] ?? 0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Total item terjual: '),
                          Text((mainItem?['totalAmount'] ?? "").toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Total komisi: '),
                          Text(
                            formatCurrency(
                              mainItem?['totalShopAllCommission'] ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              item['Refrigerators'] == null
                                  ? 0
                                  : item['Refrigerators'].length,
                          itemBuilder: (context, index) {
                            var freezer = item['Refrigerators'][index];
                            return Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "${freezer['name']} (${freezer['serialNumber']})",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
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

                  GradientElevatedButton(
                    // inactiveDelay: Duration.zero,
                    buttonHeight: 34,
                    onPressed: () async {
                      await get<StockViewModel>().getStockResume(
                        context: context,
                        salesId: null,
                        agentId: null,
                        shopId: item['id'],
                        subAgentId: null,
                      );
                      await get<StockViewModel>().getTableByShopId(
                        context: context,
                        shopId: item['id'],
                      );
                    },
                    child: Icon(Icons.search, color: Colors.white, size: 30),
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
                      return ClientDetailCard(item: item);
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
}
