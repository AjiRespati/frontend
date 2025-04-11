import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/components/client_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
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
            return ClientCard(item: item, key: ValueKey(index + 3000));
          },
        ),
      ),
    );
  }
}
