import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/components/add_shop.dart';
import 'package:frontend/src/features/shops/components/shop_table_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ShopsMobile extends StatelessWidget with GetItMixin {
  ShopsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shops);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko'),
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
          AddButton(
            size: 32,
            message: "Tambah Toko",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: 540),
                context: context,
                builder: (context) {
                  return AddShop();
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height:
                  (MediaQuery.of(context).size.height - 150) -
                  (kIsWeb ? 5 : 50),
              child: ListView.builder(
                itemCount: get<StockViewModel>().shops.length,

                itemBuilder: (context, index) {
                  return ShopTableCard(
                    isMobile: true,
                    shop: get<StockViewModel>().shops[index],
                    stockStatus: 'settled',
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
