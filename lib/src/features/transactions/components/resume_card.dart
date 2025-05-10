import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/canceling_stock.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ResumeCard extends StatelessWidget with GetItMixin {
  ResumeCard({
    super.key,
    required this.stock,
    required this.totalProduct,
    required this.totalItem,
    required this.totalPrice,
    required this.level,
    required this.stocks,
    required this.onSelect,
  });

  final Map<String, dynamic> stock;
  final int totalProduct;
  final int totalItem;
  final double totalPrice;
  final int level;
  final List stocks;
  final Function()? onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
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
                        if (stock['userDesc'] == "Shop" &&
                            (level == 4 || level == 5))
                          Row(
                            children: [
                              Text((stock['parentType'] ?? " -") + ":"),
                            ],
                          ),
                        if (stock['userDesc'] == "Shop" &&
                            (level == 4 || level == 5))
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                stock['parentEmail'] ?? " -",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                  SizedBox(width: 10),
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
                                fontSize: 16,
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
              if (((level > 0 && level < 4) &&
                      stock['status'] == 'completed') ||
                  (stock['status'] == 'completed' &&
                      level == 6 &&
                      stock['userDesc'] == "Shop"))
                IconButton(
                  onPressed: () async {
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
                  icon: Icon(
                    Icons.delete,
                    size: 26,
                    color: Colors.blue.shade600,
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
        return Colors.amber.shade900;
      case "processing":
        return Colors.yellow.shade900;
      case "failed":
        return Colors.red;
      case "settled":
        return Colors.green.shade700;
      case "canceled":
        return Colors.blue.shade700;
      default:
        return Colors.black;
    }
  }
}
