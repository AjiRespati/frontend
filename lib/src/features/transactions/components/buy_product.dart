// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/models/product_transaction.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

/// measurements is List of "kg", "g", "liter", "bucket", "carton", "box", "pcs".
class BuyProduct extends StatelessWidget with GetItMixin {
  BuyProduct({
    required this.measurement,
    required this.mainProduct,
    required this.stockEvent,
    required this.shopId,
    super.key,
  });

  final dynamic mainProduct;
  final String measurement;
  final String stockEvent;
  final String? shopId;

  @override
  Widget build(BuildContext context) {
    var client = get<StockViewModel>().client;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: get<StockViewModel>().formKey,
        child: Column(
          children: [
            Text(
              mainProduct?['productName'] ?? "N/A",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              "Stock: ${(mainProduct?['totalStock'] ?? 0).toString()} $measurement",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Row(children: [Text("Harga:")]),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  "${formatCurrency(_generatePrice(mainProduct, client))} / $measurement ",
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(children: [Text("Jumlah")]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged:
                        (value) =>
                            get<StockViewModel>().stockAmount =
                                int.tryParse(value) ?? 0,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: Text(measurement)),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child:
                      get<StockViewModel>().stockAmount < 1
                          ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Jumlah product harus diisi",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                          : SizedBox(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(children: [Text("Harga Total:")]),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  "${formatCurrency((_generatePrice(mainProduct, client)) * (watchOnly((StockViewModel x) => x.stockAmount)))} / $measurement ",
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            GradientElevatedButton(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // inactiveDelay: Duration.zero,
              onPressed: () async {
                if (get<StockViewModel>().stockAmount == 0) {
                } else {
                  ProductTransaction val = ProductTransaction(
                    productId: mainProduct?["productId"],
                    shopId: shopId,
                    productAmount: get<StockViewModel>().stockAmount,
                    productDetail: mainProduct,
                    price: (_generatePrice(mainProduct, client)).toDouble(),
                    totalPrice:
                        ((_generatePrice(mainProduct, client)) *
                                (watchOnly(
                                  (StockViewModel x) => x.stockAmount,
                                )))
                            .toDouble(),
                    stockEvent: stockEvent,
                  );
                  get<StockViewModel>().addProductTransaction(val);
                  get<StockViewModel>().reloadBuy = mainProduct;
                  await Future.delayed(Durations.short1);
                  get<StockViewModel>().reloadBuy = null;
                  get<StockViewModel>().stockAmount = 0;
                  get<StockViewModel>().productsDetail = null;
                  Navigator.pop(context, true);
                }
              },
              child: Text(
                'Tambah Product',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _generatePrice(dynamic mainProduct, String client) {
    switch (client) {
      case "agent":
        return (mainProduct?['agentPrice'] ?? 0).toDouble();
      case "subAgent":
        return (mainProduct?['subAgentPrice'] ?? 0).toDouble();
      case "salesman":
        return (mainProduct?['salesmanPrice'] ?? 0).toDouble();

      default:
        return (mainProduct?['price'] ?? 0).toDouble();
    }
  }
}
