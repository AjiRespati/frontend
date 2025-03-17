import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

/// measurements is List of "kg", "g", "liter", "bucket", "carton", "box", "pcs".
class AddStock extends StatelessWidget with GetItMixin {
  AddStock({required this.measurements, required this.mainProduct, super.key});

  final dynamic mainProduct;
  final List<String> measurements;

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
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(isDense: true),
                    value: get<StockViewModel>().measurement,
                    items:
                        measurements.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                    onChanged: (value) {
                      get<StockViewModel>().measurement = value ?? "pcs";
                    },
                  ),
                ),
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
                  child: DropdownButtonFormField<String>(
                    value: get<StockViewModel>().stockEvent,
                    items: [
                      DropdownMenuItem(
                        value: 'stock_in',
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
                      DropdownMenuItem(
                        value: 'stock_out',
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.shopping_cart_checkout_rounded,
                              color: Colors.amber,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                            Text('Send Stock'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      get<StockViewModel>().stockEvent = value ?? "stock_in";
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 10),
            watchOnly((StockViewModel x) => x.stockEvent) == "stock_out"
                ? Column(
                  children: [
                    SizedBox(height: 10),
                    Row(children: [Text("To: ")]),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(isDense: true),
                      value: get<StockViewModel>().client,
                      items:
                          get<StockViewModel>().clients.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        get<StockViewModel>().measurement = value ?? "pcs";
                      },
                    ),
                  ],
                )
                : SizedBox(),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                isDense: true,
              ),
              onChanged: (value) => get<StockViewModel>().description = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                get<StockViewModel>().metricId = mainProduct?['metricId'];
                get<StockViewModel>().createStock(context: context);
              },
              child: Text('Create Stock'),
            ),
          ],
        ),
      ),
    );
  }
}
