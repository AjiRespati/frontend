// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
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
      resizeToAvoidBottomInset: true,
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
                      watchOnly((StockViewModel x) => x.isBusy)
                          ? Column(
                            children: [
                              SizedBox(height: 200),
                              Center(
                                child: SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          )
                          : ((model.level ?? 0) > 3)
                          ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    userManagementRoute,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("User Management"),

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
                              Divider(),

                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    shopsRoute,
                                    arguments: true,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Shop Management"),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          shopsRoute,
                                          arguments: true,
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
                              Divider(),

                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, freezersRoute);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Freezer Management"),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          freezersRoute,
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
                              Divider(),

                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, productsRoute);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Product Management"),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          productsRoute,
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
                              Divider(),

                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    percentagesRoute,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Percentages Management"),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          percentagesRoute,
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
                              Divider(),
                            ],
                          )
                          : SizedBox(),

                      SizedBox(height: ((model.level ?? 0) > 3 ? 70 : 300)),
                      GradientElevatedButton(
                        onPressed: () async {
                          get<StockViewModel>().isBusy = true;
                          bool isLogout = await get<SystemViewModel>().logout(
                            context: context,
                          );
                          if (isLogout) {
                            get<StockViewModel>().isBusy = false;
                            Navigator.pushReplacementNamed(
                              context,
                              signInRoute,
                            );
                          } else {
                            get<StockViewModel>().isBusy = false;
                          }
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : SizedBox(),
      ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100005)),
    );
  }
}
