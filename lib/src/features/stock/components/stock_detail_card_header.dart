import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';

class StockDetailCardHeader extends StatelessWidget {
  const StockDetailCardHeader({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      item['createdAt'] ?? "2000-01-01T01:00:00.204Z",
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${item['entityType'] == 'Unknown' ? "" : item['entityType']}:",
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
                item['stockEvent'] == 'stock_out' ? "Stock Out" : "Stock In",
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
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
