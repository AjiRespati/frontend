import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientDetailCard extends StatelessWidget with GetItMixin {
  ClientDetailCard({required this.item, super.key});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
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
                  formatCurrency(item['salesmanPrice'] ?? 0),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              children: [
                Text("Komisi: "),
                Text(
                  formatCurrency(item['totalSalesShare'] ?? 0),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
