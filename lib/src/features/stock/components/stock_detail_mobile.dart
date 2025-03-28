import 'package:flutter/material.dart';
import 'package:flutter_corner_banner/flutter_corner_banner.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockDetailMobile extends StatelessWidget with GetItMixin {
  StockDetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var stocks = get<StockViewModel>().stockHistoryTable;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stock Detail",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
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
                      height: MediaQuery.of(context).size.height - 155,
                      child: ListView.builder(
                        itemCount: stocks.length,
                        itemBuilder: (context, idx) {
                          var item = stocks[idx];
                          bool isNew = item['status'] == 'created';
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
                                        ? const Color.fromARGB(
                                          65,
                                          240,
                                          105,
                                          148,
                                        )
                                        : Colors.transparent,
                                shadow: BoxShadow(
                                  color:
                                      isNew
                                          ? Color.fromARGB(65, 240, 105, 148)
                                          : Colors.transparent,
                                ),
                                child: Card(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
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
                                                  item['stockEvent'] ==
                                                          'stock_out'
                                                      ? "Stock Out"
                                                      : "Stock In",
                                                ),
                                                Text(
                                                  "${item['amount']}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color:
                                                        item['stockEvent'] ==
                                                                'stock_out'
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
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
