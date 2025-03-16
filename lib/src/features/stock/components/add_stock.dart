import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddStock extends StatelessWidget with GetItMixin {
  AddStock({required this.mainProduct, super.key});

  final dynamic mainProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: get<StockViewModel>().formKey,
        child: Column(
          children: [
            Text(mainProduct?['productName'] ?? "N/A"),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      suffix: Text(mainProduct?['metricType'] ?? "N/A"),
                    ),
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
                    value: get<StockViewModel>().stockEvent,
                    items: [
                      DropdownMenuItem(
                        value: 'stock_in',
                        child: Text('Stock In'),
                      ),
                      DropdownMenuItem(
                        value: 'stock_out',
                        child: Text('Stock Out'),
                      ),
                    ],
                    onChanged: (value) {
                      get<StockViewModel>().stockEvent = value ?? "stock_in";
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Created By'),
              onChanged: (value) => get<StockViewModel>().createdBy = value,
            ),
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Sales ID (optional)'),
            //   onChanged: (value) => salesId = value,
            // ),
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Sub-Agent ID (optional)'),
            //   onChanged: (value) => subAgentId = value,
            // ),
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Agent ID (optional)'),
            //   onChanged: (value) => agentId = value,
            // ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description (optional)'),
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
