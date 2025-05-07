import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/components/add_shop.dart';
import 'package:frontend/src/features/shops/components/shop_table_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ShopsMobile extends StatelessWidget with GetItMixin {
  ShopsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shops);
    watchOnly((StockViewModel x) => x.reloadBuy);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          if (0 < (get<SystemViewModel>().level ?? 0) ||
              (get<SystemViewModel>().level ?? 0) < 4)
            AddButton(
              size: 32,
              message: "Tambah Toko",
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: 740),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(child: AddShop()),
                    );
                  },
                );
              },
            ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: get<StockViewModel>().shops.length,
              itemBuilder: (context, index) {
                return ShopTableCard(
                  isMobile: true,
                  shop: get<StockViewModel>().shops[index],
                  isClient:
                      (get<SystemViewModel>().level ?? 0) < 4 &&
                      (get<SystemViewModel>().level ?? 0) > 5,
                  key: ValueKey(index + 7000),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100006)),
    );
  }
}
