import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientDetailCard extends StatelessWidget with GetItMixin {
  ClientDetailCard({required this.item, super.key});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shopStockTable);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['productName'],
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  item['shopName'],
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              children: [
                Text("Jumlah: "),
                Text(
                  "${item['amount'].toString()} ${item['metricType']}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(formatDateString(item['updatedAt'])),
              ],
            ),
            Row(
              children: [
                Text("Harga: "),
                Text(
                  formatCurrency(_generatePrice(item)),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              children: [
                Text("Komisi: "),
                Text(
                  formatCurrency(_generateKomisi(item)),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _generatePrice(dynamic item) {
    double result = 0;

    if (item['salesmanPrice'].toDouble() > 0) {
      result = item['salesmanPrice'].toDouble();
    } else if (item['subAgentPrice'].toDouble() > 0) {
      result = item['subAgentPrice'].toDouble();
    } else if (item['agentPrice'].toDouble() > 0) {
      result = item['agentPrice'].toDouble();
    }

    return result;
  }

  double _generateKomisi(dynamic item) {
    double result = 0;

    if (item['totalSalesShare'] != null &&
        item['totalSalesShare'].toDouble() > 0) {
      result = item['totalSalesShare'].toDouble();
    } else if (item['totalSubAgentShare'] != null &&
        item['totalSubAgentShare'].toDouble() > 0) {
      result = item['totalSubAgentShare'].toDouble();
    } else if (item['totalAgentShare'] != null &&
        item['totalAgentShare'].toDouble() > 0) {
      result = item['totalAgentShare'].toDouble();
    }

    return result;
  }
}
