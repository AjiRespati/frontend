// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PercentagesMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PercentagesMobile({super.key});

  @override
  State<PercentagesMobile> createState() => _PercentagesMobileState();
}

class _PercentagesMobileState extends State<PercentagesMobile>
    with GetItStateMixin {
  final TextEditingController _percentageController = TextEditingController();
  String? _selectedPercentage;

  Future<bool?> _submit() async {
    int value = int.parse(_percentageController.text.replaceAll("%", ""));
    bool? resp = await get<StockViewModel>().createPercentages(
      key: _selectedPercentage ?? "",
      value: value,
    );
    _percentageController.text = "";
    get<StockViewModel>().isBusy = false;
    Navigator.pop(context, resp);
    return resp;
  }

  Future<bool?> _update(String id) async {
    int value = int.parse(_percentageController.text.replaceAll("%", ""));
    bool? resp = await get<StockViewModel>().updatePercentages(
      context: context,
      id: id,
      value: value,
    );
    _percentageController.text = "";
    get<StockViewModel>().isBusy = false;
    Navigator.pop(context, resp);
    return resp;
  }

  @override
  void dispose() {
    super.dispose();
    _percentageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.percentages);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Percentages",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          if (watchOnly((StockViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          Text("Add"),
          SizedBox(width: 5),
          AddButton(
            size: 30,
            message: "Add",
            onPressed: () async {
              //TODO: Add Percentage
              bool? result = await showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(minHeight: 400, maxHeight: 420),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Add Percentages",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        // ✅ Metric Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedPercentage,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPercentage = newValue;
                            });
                          },
                          items:
                              [
                                "supplier",
                                "distributor",
                                "shop",
                                "agent",
                                "subAgent",
                                "salesman",
                              ].map((metric) {
                                return DropdownMenuItem(
                                  value: metric,
                                  child: Text(metric.toUpperCase()),
                                );
                              }).toList(),
                          decoration: InputDecoration(labelText: "Client"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: _percentageController,
                                decoration: InputDecoration(
                                  labelText: "Value",
                                  suffixText: "%",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Stack(
                          children: [
                            GradientElevatedButton(
                              onPressed: () async {
                                await _submit();
                              },
                              child: Text(
                                "Add Percentage",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                if (watchOnly((StockViewModel x) => x.isBusy))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    backgroundColor: Colors.green.shade400,
                    content: Text("Berhasil menambahkan persentase"),
                  ),
                );
              } else if (result == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    backgroundColor: Colors.red.shade400,
                    content: Text(
                      "Kesalahan system, hubungi pengembang aplikasi",
                    ),
                  ),
                );
              } else {
                Navigator.pushNamed(context, percentagesRoute);
              }
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: watchOnly((StockViewModel x) => x.percentages).length,
            itemBuilder: (context, index) {
              var item = get<StockViewModel>().percentages[index];
              return Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 2.0,
                  bottom: 2,
                  right: 20,
                ),
                child: SizedBox(
                  height: 60,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              item['key'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            item['value'].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () async {
                              //TODO: UPDATE PERCENTAGE
                              bool? result = await showModalBottomSheet(
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  minHeight: 400,
                                  maxHeight: 420,
                                ),
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          item['key'].toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Text(
                                          "Update Percentages",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextField(
                                                controller:
                                                    _percentageController,
                                                decoration: InputDecoration(
                                                  labelText: "Value",
                                                  suffixText: "%",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Stack(
                                          children: [
                                            GradientElevatedButton(
                                              onPressed: () async {
                                                await _update(item['id']);
                                              },
                                              child: Text(
                                                "Update Percentage",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                if (watchOnly(
                                                  (StockViewModel x) =>
                                                      x.isBusy,
                                                ))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 5,
                                                        ),
                                                    child: SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child:
                                                          CircularProgressIndicator(
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );

                              if (result == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    showCloseIcon: true,
                                    backgroundColor: Colors.green.shade400,
                                    content: Text("Berhasil update persentase"),
                                  ),
                                );
                              } else if (result == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    showCloseIcon: true,
                                    backgroundColor: Colors.red.shade400,
                                    content: Text(
                                      "Kesalahan system, hubungi pengembang aplikasi",
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(context, percentagesRoute);
                              }
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100003)),
    );
  }
}
