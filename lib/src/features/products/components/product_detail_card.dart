// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductDetailCard extends StatefulWidget with GetItStatefulWidgetMixin {
  ProductDetailCard({required this.product, super.key});
  final dynamic product;

  @override
  State<ProductDetailCard> createState() => _ProductDetailCardState();
}

class _ProductDetailCardState extends State<ProductDetailCard>
    with GetItStateMixin {
  final TextEditingController _priceController = TextEditingController();
  String _productId = "";
  String _priceId = "";
  // final List<dynamic>? stock;

  @override
  void initState() {
    super.initState();
    _priceId = widget.product['priceId'];
    _productId = widget.product['productId'];
  }

  @override
  Widget build(BuildContext context) {
    bool isClient =
        (get<SystemViewModel>().level ?? 0) < 4 ||
        (get<SystemViewModel>().level ?? 0) > 5;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Jenis Ukuran Unit:  "),
                    Text(
                      widget.product['metricType'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("Harga: "),
                    Text(
                      "${formatCurrency(widget.product['price'] ?? 0)} / ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red[900],
                      ),
                    ),
                    Text(
                      widget.product['metricType'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red[900],
                      ),
                    ),
                    SizedBox(width: 20),
                    if (!isClient)
                      AddButton(
                        color: Colors.grey,
                        altIcon: Icons.edit,
                        size: 20,
                        message: "Edit Product Price",
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              maxHeight: 700,
                              minHeight: 550,
                            ),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 30),
                                        Icon(
                                          Icons.edit,
                                          size: 38,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(height: 10),
                                        Text(widget.product?['productName']),
                                        Text(
                                          "Ganti Harga Product",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextField(
                                          controller: _priceController,
                                          decoration: InputDecoration(
                                            labelText: "Harga",
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: 90,
                                              child: GradientElevatedButton(
                                                // inactiveDelay: Duration.zero,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            SizedBox(
                                              height: 40,
                                              width: 90,
                                              child: GradientElevatedButton(
                                                // inactiveDelay: Duration.zero,
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(
                                                      30,
                                                      241,
                                                      107,
                                                      1,
                                                    ),
                                                    Colors.green,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                onPressed: () async {
                                                  //TODO: KIRIM UPDATE
                                                  await get<StockViewModel>()
                                                      .updatePrice(
                                                        context,
                                                        _productId,
                                                        _priceId,
                                                        double.parse(
                                                          _priceController.text,
                                                        ),
                                                      );
                                                  await get<StockViewModel>()
                                                      .fetchProduct(
                                                        context,
                                                        _productId,
                                                        false,
                                                      );
                                                  Navigator.pop(context, true);
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
                Row(
                  children: [
                    Text("Harga konsumen: "),
                    Text(
                      "${formatCurrency(widget.product['netPrice'] ?? 0)} / ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red[900],
                      ),
                    ),
                    Text(
                      widget.product['metricType'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("Stock On Hand:  "),
                    Text(
                      (widget.product['totalStock'] ?? 0).toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Column(
            //   children: [
            //     SizedBox(
            //       width: 120,
            //       child: GradientElevatedButton(
            //         padding: EdgeInsets.zero,
            //         buttonHeight: 25,
            //         onPressed: () {
            //           showModalBottomSheet(
            //             isScrollControlled: true,
            //             constraints: BoxConstraints(maxHeight: 540),
            //             context: context,
            //             builder: (context) {
            //               return AddStock(
            //                 measurement:
            //                     product['metricType'].toString().toLowerCase(),
            //                 mainProduct: product,
            //               );
            //             },
            //           );
            //         },
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(
            //               Icons.add_circle_outline_rounded,
            //               size: 18,
            //               color: Colors.white,
            //             ),
            //             SizedBox(width: 5),
            //             Text(
            //               "Add Stock",
            //               style: TextStyle(color: Colors.white, fontSize: 12),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(height: 10),
            //     SizedBox(
            //       width: 120,
            //       child: GradientElevatedButton(
            //         padding: EdgeInsets.zero,
            //         gradient: LinearGradient(
            //           colors: [Colors.green.shade300, Colors.green.shade700],
            //           begin: Alignment.topLeft,
            //           end: Alignment.bottomRight,
            //         ),
            //         // inactiveDelay: Duration.zero,
            //         buttonHeight: 25,
            //         onPressed:
            //             product['totalStock'] == null ||
            //                     product['totalStock'] == 0
            //                 ? null
            //                 : () {
            //                   showModalBottomSheet(
            //                     isScrollControlled: true,
            //                     constraints: BoxConstraints(maxHeight: 540),
            //                     context: context,
            //                     builder: (context) {
            //                       return SendStock(
            //                         measurement:
            //                             product['metricType']
            //                                 .toString()
            //                                 .toLowerCase(),
            //                         mainProduct: product,
            //                         stockOnHand: product['totalStock'] ?? 0,
            //                       );
            //                     },
            //                   );
            //                 },
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(
            //               Icons.shopping_cart_checkout_rounded,
            //               size: 18,
            //               color: Colors.white,
            //             ),
            //             SizedBox(width: 5),
            //             Text(
            //               "Send Stock",
            //               style: TextStyle(color: Colors.white, fontSize: 12),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
