// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/remove_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import '../../../../application_info.dart';
import 'package:intl/intl.dart'; // ✅ For formatting dates

class ProductCard extends StatelessWidget with GetItMixin {
  ProductCard({super.key, required this.isMobile, required this.product});

  final Map<String, dynamic> product;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    String imageUrl = ApplicationInfo.baseUrl + (product['image'] ?? '');
    String formattedStockIn =
        product['last_stock_in'] != null
            ? DateFormat.yMMMd().format(
              DateTime.parse(product['last_stock_in']),
            )
            : "N/A";

    String formattedStockOut =
        product['last_stock_out'] != null
            ? DateFormat.yMMMd().format(
              DateTime.parse(product['last_stock_out']),
            )
            : "N/A";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                productDetailRoute,
                arguments: product["productId"],
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child:
                        product['image'] != null
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

                // ✅ Product Details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Product Name
                      Text(
                        product['productName'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // // ✅ Price
                      // Text(
                      //   "Rp${product['price'] ?? 0}/${product['metricType'] ?? "pcs"}",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.green[600],
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                      // ✅ Description
                      Text(
                        product['description'] ?? "No description",
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // ✅ Stock Amount
                      Text(
                        "Stock: ${product['totalStock'] ?? 0}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      // ✅ Last Stock In Date
                      Text(
                        "Last In: $formattedStockIn",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                        ),
                      ),

                      // ✅ Last Stock Out Date
                      Text(
                        "Last Out: $formattedStockOut",
                        style: const TextStyle(fontSize: 11, color: Colors.red),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [const SizedBox(height: 4)],
                          ),
                          const Spacer(),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [const SizedBox(height: 4)],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if ((watchOnly((SystemViewModel x) => x.level) ?? 0) > 3)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RemoveButton(
                size: 21,
                toolTip: "Hapus product ini?\n${product['productName']}",
                title: "Hapus Product",
                onPressed: () async {
                  await get<StockViewModel>().removeProduct(
                    context: context,
                    productId: product['productId'],
                    name: null,
                    status: 'inactive',
                    description: null,
                  );
                  Navigator.pushNamed(context, productsRoute);
                },
              ),
            ),
        ],
      ),
    );
  }
}
