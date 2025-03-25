import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockDetailMobile extends StatelessWidget with GetItMixin {
  StockDetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stock Detail",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SizedBox(
        child: ListView.builder(
          itemCount: get<StockViewModel>().stockHistoryTable.length,
          itemBuilder: (context, idx) {
            var item = get<StockViewModel>().stockHistoryTable[idx];
            return Card(
              child: Column(
                children: [
                  Text(item['stockEvent']),
                  Text("${item['entityType']}: ${item['relatedEntity']}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
