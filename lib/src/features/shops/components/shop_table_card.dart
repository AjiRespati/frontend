// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

class ShopTableCard extends StatelessWidget with GetItMixin {
  ShopTableCard({
    super.key,
    required this.isMobile,
    required this.isClient,
    required this.shop,
  });

  final Map<String, dynamic> shop;
  final bool isMobile;
  final bool isClient;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap:
            isClient
                ? null
                : () {
                  Navigator.pushNamed(
                    context,
                    shopsDetailRoute,
                    arguments: shop,
                  );
                  // // print(shop);
                  // showModalBottomSheet(
                  //   isScrollControlled: true,
                  //   constraints: BoxConstraints(maxHeight: 640),
                  //   context: context,
                  //   builder: (context) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(
                  //         bottom: MediaQuery.of(context).viewInsets.bottom,
                  //       ),
                  //       child: SingleChildScrollView(
                  //         child: UpdateShop(shop: shop),
                  //       ),
                  //     );
                  //   },
                  // );
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
                flex: 6,
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
              SizedBox(width: 5),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    if (shop['Salesman'] != null)
                      Row(children: [Text("Sales:")]),
                    if (shop['Salesman'] != null)
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            shop['Salesman']['name'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    if (shop['SubAgent'] != null)
                      Row(children: [Text("Sub Agent:")]),
                    if (shop['SubAgent'] != null)
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            shop['SubAgent']['name'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    if (shop['Agent'] != null) Row(children: [Text("Agent:")]),
                    if (shop['Agent'] != null)
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            shop['Agent']['name'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    Row(children: [Text("Freezer:")]),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        height: 55,
                        child: ListView.builder(
                          itemCount:
                              shop['Refrigerators'] == null
                                  ? 0
                                  : shop['Refrigerators'].length,
                          itemBuilder: (context, index) {
                            var item = shop['Refrigerators'][index];
                            return Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "${item['name']} (${item['serialNumber']})",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isClient)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          shopsDetailRoute,
                          arguments: shop,
                        );
                        // showModalBottomSheet(
                        //   isScrollControlled: true,
                        //   constraints: BoxConstraints(maxHeight: 640),
                        //   context: context,
                        //   builder: (context) {
                        //     return Padding(
                        //       padding: EdgeInsets.only(
                        //         bottom:
                        //             MediaQuery.of(context).viewInsets.bottom,
                        //       ),
                        //       child: SingleChildScrollView(
                        //         child: UpdateShop(shop: shop),
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      icon: Icon(Icons.chevron_right_outlined, size: 40),
                    ),
                  ],
                ),
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
