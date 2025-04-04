// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SettingsMobile extends StatelessWidget with GetItMixin {
  SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user = watchOnly((SystemViewModel x) => x.level);
    SystemViewModel model = get<SystemViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child:
            user != null
                ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text("Username: ${model.username}"),
                      Text("Name: ${model.name}"),
                      Text("Level: ${model.level ?? 0}"),
                      SizedBox(height: 30),
                      Divider(),
                      if ((model.level ?? 0) > 3)
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, userManagementRoute);
                          },
                          child: Row(
                            children: [
                              Text("User Management"),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    userManagementRoute,
                                  );
                                },
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if ((model.level ?? 0) > 3) Divider(),
                      if ((model.level ?? 0) > 3)
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, freezersRoute);
                          },
                          child: Row(
                            children: [
                              Text("Freezer Management"),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, freezersRoute);
                                },
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if ((model.level ?? 0) > 3) Divider(),
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                                        (model.level ?? 0) >
                                    4
                                ? 340
                                : 500,
                      ),
                      GradientElevatedButton(
                        onPressed: () async {
                          bool isLogout = await get<SystemViewModel>().logout(
                            context: context,
                          );
                          if (isLogout) {
                            Navigator.pushReplacementNamed(
                              context,
                              signInRoute,
                            );
                          }
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                )
                : SizedBox(),
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
