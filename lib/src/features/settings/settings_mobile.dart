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

                              if (model.username == 'aji@mail.com' ||
                                  model.username == 'aji.b.respati@gmail.com')
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom,
                                          ),
                                          child: SingleChildScrollView(
                                            child: TruncateTable(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Developers"),
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
                              if (model.username == 'aji@mail.com' ||
                                  model.username == 'aji.b.respati@gmail.com')
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

class TruncateTable extends StatefulWidget with GetItStatefulWidgetMixin {
  TruncateTable({super.key});

  @override
  State<TruncateTable> createState() => _TruncateTableState();
}

class _TruncateTableState extends State<TruncateTable> with GetItStateMixin {
  String? message;
  String? tableChoosen;
  List<String> tables = [
    'User',
    'Salesman',
    'SubAgent',
    'Agent',
    'Shop',
    'SalesmanCommission',
    'SubAgentCommission',
    'AgentCommission',
    'DistributorCommission',
    'ShopAllCommission',
    'StockBatch',
    'Stock',
    'Price',
    'Metric',
    'Product',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "Table Table",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(message ?? "-", style: TextStyle(color: Colors.red.shade800)),
          SizedBox(height: 40),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(isDense: true),
            value: tableChoosen,
            items:
                tables.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              tableChoosen = value;
              setState(() {});
            },
          ),

          SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GradientElevatedButton(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("CANCEL"),
              ),
              GradientElevatedButton(
                onPressed: () async {
                  bool result = await get<SystemViewModel>().genericTable(
                    context: context,
                    table: tableChoosen ?? "-",
                  );

                  if (result) {
                    setState(() {
                      message = "Truncate success";
                    });
                  } else {
                    setState(() {
                      message = "Truncate error";
                    });
                  }
                  await Future.delayed(Duration(seconds: 2));
                },
                child: Text("TRUNCATE"),
              ),
            ],
          ),

          SizedBox(height: 40),

          SizedBox(height: 60),
        ],
      ),
    );
  }
}
