import 'package:flutter/material.dart';
import 'package:frontend/src/features/products/components/add_product.dart';
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
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  constraints: BoxConstraints(minHeight: 600, maxHeight: 620),
                  context: context,
                  builder: (context) {
                    return AddProductScreen();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                formatMonthDay(
                                  item['createdAt'] ??
                                      "2000-01-01T01:00:00.204Z",
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${item['entityType'] == 'Unknown' ? "Produsen" : item['entityType']}:",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Flexible(
                                child: Text(
                                  "${item['relatedEntity'] == 'N/A' ? "Gracia Factory" : item['relatedEntity']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            item['stockEvent'] == 'stock_out'
                                ? "Stock Out"
                                : "Stock In",
                          ),
                          Text(
                            "${item['amount']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color:
                                  item['stockEvent'] == 'stock_out'
                                      ? Colors.red
                                      : Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Amount"),
                          Text(
                            "${item['updateAmount']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
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
