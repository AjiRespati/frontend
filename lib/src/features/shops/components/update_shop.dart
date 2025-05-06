// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/components/update_freezer_status.dart';
import 'package:frontend/src/models/freezer_status.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdateShop extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateShop({required this.shop, super.key});
  final Map<String, dynamic> shop;

  @override
  State<UpdateShop> createState() => _UpdateShopState();
}

class _UpdateShopState extends State<UpdateShop> with GetItStateMixin {
  final ApiService apiService = ApiService();
  dynamic _selectedFrezer;
  String oldStatus = "ACTIVE";
  String? _message;
  bool _isClient = true;

  void _submit() async {
    var shopInfo = widget.shop;
    var freezerInfo = _selectedFrezer;
    if (freezerInfo != null) {
      await get<StockViewModel>().updateFreezerShop(
        context: context,
        id: freezerInfo['id'],
        shopId: shopInfo['id'],
        status: "active",
      );
    }

    await get<StockViewModel>().updateShop(
      context: context,
      id: shopInfo['id'],
      name: null,
      image: null,
      address: null,
      coordinates: null,
      phone: null,
      email: null,
      status: oldStatus.toLowerCase(),
    );

    await get<StockViewModel>().getAllShops(context: context);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // print(widget.shop);
    oldStatus = widget.shop["status"].toString().toUpperCase();
    _isClient =
        (get<SystemViewModel>().level ?? 0) < 4 &&
        (get<SystemViewModel>().level ?? 0) > 5;
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shops);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "${widget.shop['name']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            "${(widget.shop['status'] ?? "").toUpperCase()}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: statusColor(widget.shop['status'] ?? ""),
            ),
          ),
          SizedBox(height: 15),
          Divider(),

          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  widget.shop['Refrigerators'] == null
                      ? 0
                      : widget.shop['Refrigerators'].length,
              itemBuilder: (context, index) {
                var freezer = widget.shop['Refrigerators'][index];
                var freezerStatus = freezer['status'];
                return Padding(
                  key: ValueKey(index + 9000),
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${freezer['name']} (${freezer['serialNumber']})",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            freezerStatusFromString(freezerStatus).displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: statusColor(freezerStatus),
                            ),
                          ),
                          SizedBox(width: 30),
                          InkWell(
                            onTap: () async {
                              bool? result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: UpdateFreezerStatus(
                                      freezer: freezer,
                                      selectedStatus: (newStatus) {
                                        setState(() {
                                          freezerStatus = newStatus?.name;
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                              if (result == true) {
                                get<StockViewModel>().reloadBuy = true;
                                setState(() {
                                  _message = "Berhasil update status freezer";
                                });
                                await Future.delayed(Durations.extralong4);
                                get<StockViewModel>().reloadBuy = null;

                                setState(() {
                                  _message = null;
                                });
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else if (result == false) {
                                setState(() {
                                  _message =
                                      "Update status freezer tidak berhasil";
                                });
                                await Future.delayed(Durations.extralong4);
                                setState(() {
                                  _message = null;
                                });
                              } else {
                                setState(() {
                                  _message = "test";
                                });
                                await Future.delayed(Durations.extralong4);
                                setState(() {
                                  _message = null;
                                });
                              }
                            },
                            child: Icon(Icons.edit, size: 18),
                          ),
                        ],
                      ),
                      Row(children: [Text(freezer['description'] ?? "")]),
                    ],
                  ),
                );
              },
            ),
          ),

          if (!_isClient) Row(children: [Text("Kirim Freezer")]),
          if (!_isClient)
            DropdownSearch<dynamic>(
              decoratorProps: DropDownDecoratorProps(
                baseStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ), // Style for text inside the closed dropdown
              ),
              popupProps: PopupProps.menu(
                // Or .dialog(), .modalBottomSheet(), .menu()
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    hintText: "Cari freezer...",
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                ),
                itemBuilder: _customPopupItemBuilder,
              ),
              // *** Core properties (mostly unchanged in how they are used) ***
              items:
                  (filter, loadProps) =>
                      get<StockViewModel>().idleFreezers, // The list of items
              onChanged: (dynamic newValue) {
                // Callback when an item is selected
                setState(() {
                  _selectedFrezer = newValue;
                  // print("Selected shop: $_selectedFrezer");
                });
              },
              selectedItem: _selectedFrezer, // The currently selected item
              // *** Optional: Customize the display of the selected item when closed ***
              // This builder is still valid at the top level
              dropdownBuilder: (context, selectedItem) {
                if (selectedItem == null) {
                  // Use hint style from decoration if available and item is null
                  final hintStyle =
                      Theme.of(context).inputDecorationTheme.hintStyle ??
                      TextStyle(color: Colors.grey[600]);
                  return Text("Pilih freezer", style: hintStyle);
                }
                return Text(
                  "${selectedItem['name']} (${selectedItem['serialNumber']})",
                );
              },
              filterFn: (item, filter) {
                // Optional: Custom filter logic
                if (filter.isEmpty) return true; // Show all if search is empty
                // Case-insensitive search
                return item['name'].toLowerCase().contains(
                  filter.toLowerCase(),
                );
              },
              compareFn: (item1, item2) => item1['id' == item2['id']],
            ),

          SizedBox(height: 10),
          if (!_isClient) Row(children: [Text("Update Status Toko")]),
          if (!_isClient)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(isDense: true),
              value: oldStatus,
              items:
                  ["ACTIVE", "INACTIVE"].map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: (value) {
                oldStatus = value ?? "new";
                setState(() {});
              },
            ),

          Stack(
            children: [
              SizedBox(height: 40),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _message ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              (_message ?? "").contains('tidak')
                                  ? Colors.red.shade600
                                  : Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (!_isClient)
            Stack(
              children: [
                GradientElevatedButton(
                  // inactiveDelay: Duration.zero,
                  onPressed: _submit,
                  child: Text(
                    "Update Toko",
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
          if (!_isClient) SizedBox(height: 400),

          if (_isClient)
            GradientElevatedButton(
              // inactiveDelay: Duration.zero,
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Tutup",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (_isClient) SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    dynamic item,
    bool isDisabled,
    bool isSelected,
  ) {
    // --- You can now use the 'isDisabled' flag ---
    Color textColor = Colors.black87; // Default text color
    FontWeight fontWeight = FontWeight.normal;

    if (isDisabled) {
      textColor =
          Colors.grey; // Style disabled items differently (e.g., greyed out)
    } else if (isSelected) {
      textColor = Theme.of(context).primaryColor; // Highlight selected
      fontWeight = FontWeight.bold;
    }
    // --- End of using 'isDisabled' ---

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // You might want to prevent interaction if isDisabled is true,
      // though the dropdown often handles this already.
      child: Text(
        "${item['name']} (${item['serialNumber']})",
        style: TextStyle(
          fontSize: 16,
          color: textColor, // Use the determined color
          fontWeight: fontWeight, // Use the determined weight
          // decoration: isDisabled ? TextDecoration.lineThrough : null, // Optional: strike-through
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
