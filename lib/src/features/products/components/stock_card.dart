import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockCard extends StatelessWidget with GetItMixin {
  StockCard({required this.product, required this.stock, super.key});
  final dynamic product;
  final List<dynamic> stock;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        children: [Text(product['metricType'].toString().toUpperCase())],
      ),
    );
  }
}
