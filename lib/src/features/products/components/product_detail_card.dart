import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/add_stock.dart';
import 'package:frontend/src/features/stock/components/send_stock.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductDetailCard extends StatelessWidget with GetItMixin {
  ProductDetailCard({required this.product, super.key});
  final dynamic product;
  // final List<dynamic>? stock;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Jenis Ukuran Unit:  "),
                    Text(
                      product['metricType'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("Harga awal: "),
                    Text(
                      "${formatCurrency(product['price'])} / ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                    Text(
                      product['metricType'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Harga: "),
                    Text(
                      "${formatCurrency(product['netPrice'])} / ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                    Text(
                      product['metricType'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("Stock On Hand:  "),
                    Text(
                      (product['totalStock'] ?? 0).toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 120,
                  child: GradientElevatedButton(
                    inactiveDelay: Duration.zero,
                    buttonHeight: 25,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        constraints: BoxConstraints(maxHeight: 540),
                        context: context,
                        builder: (context) {
                          return AddStock(
                            measurement:
                                product['metricType'].toString().toLowerCase(),
                            mainProduct: product,
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Add Stock",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 120,
                  child: GradientElevatedButton(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade300, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    inactiveDelay: Duration.zero,
                    buttonHeight: 25,
                    onPressed:
                        product['totalStock'] == null ||
                                product['totalStock'] == 0
                            ? null
                            : () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                constraints: BoxConstraints(maxHeight: 540),
                                context: context,
                                builder: (context) {
                                  return SendStock(
                                    measurement:
                                        product['metricType']
                                            .toString()
                                            .toLowerCase(),
                                    mainProduct: product,
                                    stockOnHand: product['totalStock'] ?? 0,
                                  );
                                },
                              );
                            },
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Send Stock",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
