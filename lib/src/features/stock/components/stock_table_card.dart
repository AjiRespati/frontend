// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockTableCard extends StatelessWidget with GetItMixin {
  StockTableCard({
    super.key,
    required this.stockStatus,
    required this.isMobile,
    required this.stock,
  });

  final Map<String, dynamic> stock;
  final bool isMobile;
  final String stockStatus;

  @override
  Widget build(BuildContext context) {
    String imageUrl = ApplicationInfo.baseUrl + (stock['image'] ?? '');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          get<StockViewModel>().choosenMetricId = stock['metricId'];
          bool resp = await get<StockViewModel>().getStockHistory(
            status: stockStatus,
          );
          if (resp) Navigator.pushNamed(context, stockDetailRoute);
        },
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 90,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(10),
                  ),
                  child:
                      stock['image'] != null
                          ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                          )
                          : const Icon(Icons.image, size: 50),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          stock['productName'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Unit: "),
                        Text(
                          stock['metricName'] ?? " N/A",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Stock In: "),
                        Text((stock['totalStockIn'] ?? " N/A").toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Stock Out: "),
                        Text((stock['totalStockOut'] ?? " N/A").toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Stock On Hand: "),
                        Text(
                          (stock['latestUpdateAmount'] ?? " N/A").toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.green[800],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Last Update: "),
                        Text(
                          formatDateString(
                            (stock['lastStockUpdate'] ??
                                "2000-01-01T01:00:00.204Z"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      get<StockViewModel>().choosenMetricId = stock['metricId'];
                      bool resp = await get<StockViewModel>().getStockHistory(
                        status: stockStatus,
                      );
                      if (resp) Navigator.pushNamed(context, stockDetailRoute);
                    },
                    icon: Icon(Icons.chevron_right_outlined, size: 40),
                  ),
                ],
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
