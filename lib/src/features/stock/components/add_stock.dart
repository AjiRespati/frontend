import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

/// measurements is List of "kg", "g", "liter", "bucket", "carton", "box", "pcs".
class AddStock extends StatelessWidget with GetItMixin {
  AddStock({required this.measurement, required this.mainProduct, super.key});

  final dynamic mainProduct;
  final String measurement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: get<StockViewModel>().formKey,
        child: Column(
          children: [
            Text(
              mainProduct?['productName'] ?? "N/A",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            Row(children: [Text("Amount")]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged:
                        (value) =>
                            get<StockViewModel>().stockAmount =
                                int.tryParse(value) ?? 0,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: Text(measurement)),
                SizedBox(width: 10),
                Expanded(child: SizedBox()),
                SizedBox(width: 10),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 20),
            Row(children: [Text("Stock Event Type")]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.green,
                        size: 30,
                      ),
                      SizedBox(width: 5),
                      Text('Add Stock'),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                isDense: true,
              ),
              onChanged: (value) => get<StockViewModel>().description = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                get<StockViewModel>().metricId = mainProduct?['metricId'];
                get<StockViewModel>().stockEvent = 'stock_in';
                await get<StockViewModel>().createStock(context: context);
                await get<StockViewModel>().fetchProduct(
                  mainProduct?['productId'],
                );
                get<StockViewModel>().fetchProducts();
              },
              child: Text('Add Stock'),
            ),
          ],
        ),
      ),
    );
  }
}
