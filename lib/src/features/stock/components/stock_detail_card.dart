import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/settling_stock.dart';
import 'package:frontend/src/features/stock/components/stock_detail_card_header.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockDetailCard extends StatelessWidget with GetItMixin {
  StockDetailCard({required this.isNew, required this.item, super.key});

  final bool isNew;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRect(
        child: Banner(
          message: isNew ? 'Unpaid' : "",
          textStyle: TextStyle(
            color: Colors.red[800],
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
          location: BannerLocation.topEnd,
          color:
              isNew
                  ? const Color.fromARGB(65, 240, 105, 148)
                  : Colors.transparent,
          shadow: BoxShadow(
            color:
                isNew ? Color.fromARGB(65, 240, 105, 148) : Colors.transparent,
          ),
          child: Card(
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap:
                  !isNew
                      ? null
                      : () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            minHeight: 600,
                            maxHeight: 620,
                          ),
                          context: context,
                          builder: (context) {
                            return SettlingStock(item: item);
                          },
                        );
                      },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    StockDetailCardHeader(item: item),
                    Divider(),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Harga Total: "),
                            Text(
                              item['stockEvent'] == 'stock_out'
                                  ? formatCurrency(item['totalNetPrice'] ?? 0)
                                  : formatCurrency(item['totalPrice'] ?? 0),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                // fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        if (item['stockEvent'] == 'stock_out' &&
                            item['initialAmount'] != null)
                          Row(children: [Text("Komisi:")]),

                        if (item['totalSalesShare'] != null)
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Expanded(child: Text("Sales")),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  ": ${formatCurrency(item['totalSalesShare'])}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        if (item['totalSubAgentShare'] != null)
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Expanded(child: Text("Sub Agent")),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  ": ${formatCurrency(item['totalSubAgentShare'])}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        if (item['totalAgentShare'] != null)
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Expanded(child: Text("Agent")),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  ": ${formatCurrency(item['totalAgentShare'])}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        if (item['totalShopShare'] != null)
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Expanded(child: Text("Toko")),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  ": ${formatCurrency(item['totalShopShare'])}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10),

                        if (item['description'] != null)
                          Row(children: [Text("Keterangan:")]),

                        if (item['description'] != null)
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Flexible(
                                child: Text(
                                  item['description'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
