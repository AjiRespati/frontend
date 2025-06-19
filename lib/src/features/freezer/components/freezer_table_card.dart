// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/freezer/components/update_freezer.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

class FreezerTableCard extends StatelessWidget with GetItMixin {
  FreezerTableCard({super.key, required this.isMobile, required this.freezer});

  final Map<String, dynamic> freezer;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              freezer['image'] != null
                  ? Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.network(
                      ApplicationInfo.baseUrl + freezer['image'],
                    ),
                  )
                  : SizedBox(
                    height: 90,
                    width: 80,
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          freezer['name'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          flex: 3,
                          child: Text(
                            freezer['serialNumber'] ?? " N/A",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            freezer['capacity'] ?? " N/A",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
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
                    SizedBox(height: 8),
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
                        Flexible(
                          child: Text(
                            freezer['Shop']['address'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
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
