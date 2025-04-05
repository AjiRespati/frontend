// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/copy_to_clipboard.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientCard extends StatelessWidget with GetItMixin {
  ClientCard({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () async {
            await get<StockViewModel>().getStockResume(
              context: context,
              salesId: item['id'],
            );
            await get<StockViewModel>().getTableBySalesId(
              context: context,
              salesId: item['id'],
            );

            print(get<StockViewModel>().stockResume);
            print(get<StockViewModel>().salesStockTable);
            Navigator.pushNamed(context, clientDetailRoute, arguments: item);
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 70, child: Text("Name")),
                      Text(": ${item['name']}"),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 70, child: Text("Address")),
                      Text(": ${item['address']}"),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 70, child: Text("Phone")),
                      Text(": ${item['phone']}"),
                      SizedBox(width: 10),
                      CopyToClipboard(item['phone'], isMobile: true),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 70, child: Text("Email")),
                      Text(": ${item['email']}"),
                      SizedBox(width: 10),
                      CopyToClipboard(item['email'], isMobile: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
