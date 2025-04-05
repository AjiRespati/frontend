// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/freezer/components/update_freezer.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

class FreezerTableCard extends StatelessWidget with GetItMixin {
  FreezerTableCard({super.key, required this.isMobile, required this.freezer});

  final Map<String, dynamic> freezer;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    // String imageUrl = ApplicationInfo.baseUrl + (stock['image'] ?? '');
    print(freezer);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () async {
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
                  child: UpdateFreezer(freezer: freezer),
                ),
              );
            },
          );
        },
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          freezer['name'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          freezer['serialNumber'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          freezer['capacity'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          (freezer['status'] ?? "N/A").toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor(freezer['status']),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Text("Unit: "),
                    //     Text(
                    //       stock['metricName'] ?? " N/A",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.blue,
                    //         fontSize: 16,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Stock In: "),
                    //     Text((stock['totalStockIn'] ?? " N/A").toString()),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Stock Out: "),
                    //     Text((stock['totalStockOut'] ?? " N/A").toString()),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Stock On Hand: "),
                    //     Text(
                    //       stockStatus == 'settled'
                    //           ? (stock['latestUpdateAmount'] ?? " N/A")
                    //               .toString()
                    //           : " -",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w900,
                    //         color: Colors.green[800],
                    //         fontSize: 16,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Last Update: "),
                    //     Text(
                    //       formatDateString(
                    //         (stock['lastStockUpdate'] ??
                    //             "2000-01-01T01:00:00.204Z"),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child:
                    freezer['Shop'] != null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    freezer['Shop']['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  freezer['Shop']['address'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ],
                        )
                        : SizedBox(),
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
                              child: UpdateFreezer(freezer: freezer),
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

  // "idle", "active", "broken", "wasted"
  Color statusColor(String status) {
    switch (status) {
      case 'idle':
        return Colors.amberAccent.shade700;
      case 'active':
        return Colors.green.shade700;
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
