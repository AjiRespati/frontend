import 'package:flutter/material.dart';
import '../application_info.dart';
import 'package:intl/intl.dart'; // ✅ For formatting dates

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String imageUrl = ApplicationInfo.baseUrl + (product['image'] ?? '');
    String formattedStockIn = product['last_stock_in'] != null
        ? DateFormat.yMMMd().format(
            DateTime.parse(product['last_stock_in']),
          )
        : "N/A";

    String formattedStockOut = product['last_stock_out'] != null
        ? DateFormat.yMMMd().format(
            DateTime.parse(product['last_stock_out']),
          )
        : "N/A";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Product Image
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: product['image'] != null
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    )
                  : const Icon(Icons.image, size: 50),
            ),
          ),

          // ✅ Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ✅ Product Name
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // ✅ Price
                        Text(
                          "\$${product['price'].toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ✅ Description
                        Text(
                          product['description'] ?? "No description",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ✅ Stock Amount
                        Text(
                          "Stock: ${product['amount']}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
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
                      children: [
                        // ✅ Last Stock In Date
                        Text(
                          "Last In: $formattedStockIn",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        const SizedBox(height: 4),

                        // ✅ Last Stock Out Date
                        Text(
                          "Last Out: $formattedStockOut",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
