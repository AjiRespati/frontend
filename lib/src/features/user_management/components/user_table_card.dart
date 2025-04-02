// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserTableCard extends StatelessWidget with GetItMixin {
  UserTableCard({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    String imageUrl = ApplicationInfo.baseUrl + (user['name'] ?? '');
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
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Level: "),
                        Text(
                          user['level'].toString(),
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
                            onTap: () {},
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
                          user['status'].toString(),
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
                            onTap: () {},
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
}
