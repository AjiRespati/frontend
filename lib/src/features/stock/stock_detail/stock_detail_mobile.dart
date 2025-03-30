import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_detail_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockDetailMobile extends StatelessWidget with GetItMixin {
  StockDetailMobile({required this.status, super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    var stocks = get<StockViewModel>().stockHistoryTable;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stock Detail",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          if (watchOnly((StockViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          Text(
            status == 'created' ? "PROCESSING" : status.toUpperCase(),
            style: _generateStyle(status),
          ),
          SizedBox(width: 20),
        ],
      ),
      body:
          stocks.isEmpty
              ? SizedBox(
                child: Text(
                  "Tidak ada stock yang perlu diproses didalam filter tanggal.",
                ),
              )
              : Column(
                children: [
                  Text(
                    stocks.first['productName'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "(${stocks.first['measurement']})",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  stocks.first?['updateAmount'] == null
                      ? SizedBox(height: 15)
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Stock Amount:"),
                          SizedBox(width: 5),
                          Text(stocks.first['updateAmount'].toString()),
                          SizedBox(width: 20),
                        ],
                      ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 175,
                      child: ListView.builder(
                        itemCount: stocks.length,
                        itemBuilder: (context, idx) {
                          var item = stocks[idx];
                          bool isNew = item['status'] == 'created';
                          return StockDetailCard(isNew: isNew, item: item);
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  TextStyle _generateStyle(String status) {
    switch (status) {
      case 'canceled':
        return TextStyle(color: Colors.red[800], fontWeight: FontWeight.w700);
      case 'created':
        return TextStyle();

      default:
        return TextStyle(color: Colors.green, fontWeight: FontWeight.w900);
    }
  }
}
