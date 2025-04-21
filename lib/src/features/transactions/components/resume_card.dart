import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ResumeCard extends StatelessWidget with GetItMixin {
  ResumeCard({
    super.key,
    required this.stock,
    required this.totalProduct,
    required this.totalItem,
    required this.totalPrice,
    required this.stocks,
    required this.onSelect,
  });

  final Map<String, dynamic> stock;
  final int totalProduct;
  final int totalItem;
  final double totalPrice;
  final List stocks;
  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          formatDateStringHM(stock['createdAt']),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Dibuat oleh'),
                        SizedBox(width: 5),
                        Text(stock['userDesc']),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            stock['createdBy'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(children: [Text("Total Product: $totalProduct")]),
                    Row(children: [Text("Total Item: $totalItem")]),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text("Harga: "),
                        Text(
                          formatCurrency(totalPrice),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          stock['status'].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: _statusColorGenerator(stock['status']),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        var item = stocks[index];
                        return Row(
                          children: [
                            Flexible(
                              child: Text(
                                "${item['amount']} ${item['metricType']}, ${item['productName']}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColorGenerator(String? status) {
    // 'processing', 'completed', 'failed', 'settled', 'canceled'
    switch (status) {
      case "completed":
        return Colors.lightBlue.shade700;
      case "processing":
        return Colors.yellow.shade400;
      case "failed":
        return Colors.red;
      case "settled":
        return Colors.green;
      case "canceled":
        return Colors.orangeAccent;
      default:
        return Colors.black;
    }
  }
}
