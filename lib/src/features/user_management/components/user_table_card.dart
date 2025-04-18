// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_management/components/update_level_content.dart';
import 'package:frontend/src/features/user_management/components/update_status_content.dart';
import 'package:frontend/src/widgets/copy_to_clipboard.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserTableCard extends StatelessWidget with GetItMixin {
  UserTableCard({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () async {},
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          user['name'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Username: "),
                        Text(
                          user['email'] ?? " N/A",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 20),
                        CopyToClipboard(user['email'], isMobile: true),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Phone: "),
                        Text(
                          user['phone'] ?? " N/A",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 20),
                        CopyToClipboard(user['phone'], isMobile: true),
                        //TODO: BUKA HANYA KALAU MAU DELETE USER
                        // SizedBox(width: 20),
                        // SizedBox(
                        //   height: 25,
                        //   width: 25,
                        //   child: InkWell(
                        //     borderRadius: BorderRadius.circular(18),
                        //     onTap: () async {
                        //       print(user['id']);
                        //       await ApiService().deleteUser(user['id']);
                        //       get<SystemViewModel>().getAllUser(context);
                        //     },
                        //     child: Icon(Icons.delete_forever, size: 26),
                        //   ),
                        // ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Level/Role: "),
                        Text(
                          "${user['level'].toString()} - ${user['levelDesc'] ?? "Basic"}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.green[800],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 40),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  minHeight: 400,
                                  maxHeight: 420,
                                ),
                                context: context,
                                builder: (context) {
                                  return UpdateLevelContent(
                                    id: user['id'],
                                    username: user['username'],
                                    level: user['level'],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.edit_rounded, size: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Status: "),
                        Text(
                          user['status'].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: _generateColor(user['status'].toUpperCase()),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 40),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  minHeight: 400,
                                  maxHeight: 420,
                                ),
                                context: context,
                                builder: (context) {
                                  return UpdateStatusContent(
                                    id: user['id'],
                                    username: user['username'],
                                    oldStatus: user['status'],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.edit_rounded, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     IconButton(
              //       onPressed: () async {},
              //       icon: Icon(Icons.chevron_right_outlined, size: 40),
              //     ),
              //   ],
              // ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Color _generateColor(String status) {
    switch (status) {
      case "NEW":
        return Colors.amber.shade800;
      case "ACTIVE":
        return Colors.green.shade700;
      default:
        return Colors.red.shade600;
    }
  }
}
