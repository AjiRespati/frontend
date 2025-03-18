import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/copy_to_clipboard.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SalesmenView extends StatelessWidget with GetItMixin {
  SalesmenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: watchOnly((StockViewModel x) => x.salesmen).length,
          itemBuilder: (context, index) {
            var item = get<StockViewModel>().salesmen[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
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
            );
          },
        ),
      ),
    );
  }
}
