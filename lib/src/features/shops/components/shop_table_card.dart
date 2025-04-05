// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/components/update_shop.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

class ShopTableCard extends StatelessWidget with GetItMixin {
  ShopTableCard({super.key, required this.isMobile, required this.shop});

  final Map<String, dynamic> shop;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    // String imageUrl = ApplicationInfo.baseUrl + (stock['image'] ?? '');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          print(shop);
          showModalBottomSheet(
            isScrollControlled: true,
            constraints: BoxConstraints(maxHeight: 640),
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(child: UpdateShop(shop: shop)),
              );
            },
          );
        },
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              // SizedBox(
              //   width: 110,
              //   height: 90,
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.vertical(
              //       top: Radius.circular(10),
              //       bottom: Radius.circular(10),
              //     ),
              //     child:
              //         stock['image'] != null
              //             ? Image.network(
              //               imageUrl,
              //               width: double.infinity,
              //               fit: BoxFit.cover,
              //               errorBuilder:
              //                   (context, error, stackTrace) => const Icon(
              //                     Icons.image_not_supported,
              //                     size: 50,
              //                   ),
              //             )
              //             : const Icon(Icons.image, size: 50),
              //   ),
              // ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          shop['name'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            maxLines: 2,
                            shop['address'] ?? " N/A",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          shop['phone'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          (shop['status'] ?? " N/A").toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor(shop['status'] ?? " N/A"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Freezer:",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        itemCount:
                            shop['Refrigerators'] == null
                                ? 0
                                : shop['Refrigerators'].length,
                        itemBuilder: (context, index) {
                          var item = shop['Refrigerators'][index];
                          return Row(
                            children: [
                              Text("${item['name']} (${item['serialNumber']})"),
                            ],
                          );
                        },
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     Text(
                    //       "Freezer: ",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     Text(
                    //       shop['Refrigerators'] == null
                    //           ? " N/A"
                    //           : shop['Refrigerators'].length == 0
                    //           ? " N/A"
                    //           : shop['Refrigerators'][0]['status'],
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        constraints: BoxConstraints(maxHeight: 640),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SingleChildScrollView(
                              child: UpdateShop(shop: shop),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.chevron_right_outlined, size: 40),
                  ),
                ],
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'idle':
        return Colors.amberAccent.shade700;
      case 'active':
        return Colors.green.shade700;
      case 'inactive':
        return Colors.red.shade400;
      case 'broken':
        return Colors.red.shade700;
      case 'repairing':
        return Colors.red.shade400;
      case 'wasted':
        return Colors.blueGrey.shade900;
      default:
        return Colors.black;
    }
  }
}
