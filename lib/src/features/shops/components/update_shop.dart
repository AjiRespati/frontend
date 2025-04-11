// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/models/freezer_status.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdateShop extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateShop({required this.shop, super.key});
  final Map<String, dynamic> shop;

  @override
  State<UpdateShop> createState() => _UpdateShopState();
}

class _UpdateShopState extends State<UpdateShop> with GetItStateMixin {
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _capacityController = TextEditingController();
  // final TextEditingController _serialNumberController = TextEditingController();
  final ApiService apiService = ApiService();
  dynamic _selectedFrezer;
  String oldStatus = "ACTIVE";

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
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shops);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Update Toko",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
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
            "${widget.shop['status']}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: statusColor(widget.shop['status']),
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
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${freezer['name']} (${freezer['serialNumber']})",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        freezerStatusFromString(freezer['status']).displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: statusColor(freezer['status']),
                        ),
                      ),
                      SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: UpdateFreezerStatus(freezer: freezer),
                              );
                            },
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
                          //         child: UpdateShop(shop: widget.shop),
                          //       ),
                          //     );
                          //   },
                          // );
                        },
                        child: Icon(Icons.edit, size: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Row(children: [Text("Kirim Freezer")]),
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
              return item['name'].toLowerCase().contains(filter.toLowerCase());
            },
            compareFn: (item1, item2) => item1['id' == item2['id']],
          ),

          SizedBox(height: 10),
          Row(children: [Text("Update Status Toko")]),
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

          SizedBox(height: 40),
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
                        child: CircularProgressIndicator(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 400),
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

class UpdateFreezerStatus extends StatefulWidget {
  const UpdateFreezerStatus({super.key, required this.freezer});

  final dynamic freezer;

  @override
  State<UpdateFreezerStatus> createState() => _UpdateFreezerStatusState();
}

class _UpdateFreezerStatusState extends State<UpdateFreezerStatus> {
  // State variable to hold the currently selected status
  // No longer initialized here directly
  late FreezerStatus _selectedStatus;

  // List of all possible status values (remains the same)
  final List<FreezerStatus> _allStatuses = FreezerStatus.values;

  @override
  void initState() {
    super.initState();
    _selectedStatus = freezerStatusFromString(widget.freezer['status']);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Freezer Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.freezer['name']} (${widget.freezer['serialNumber']})",
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              freezerStatusFromString(widget.freezer['status']).displayName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade600,
              ),
            ),
            Divider(),

            // Generate RadioListTiles dynamically (logic remains the same)
            ..._allStatuses.map((status) {
              return RadioListTile<FreezerStatus>(
                dense: true,
                radioScaleFactor: 0.8,
                activeColor: Colors.blue.shade700,
                title: Text(status.displayName),
                value: status,
                groupValue:
                    _selectedStatus, // Uses the initialized _selectedStatus
                onChanged: (FreezerStatus? value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              );
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GradientElevatedButton(
                  buttonHeight: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Batal",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                GradientElevatedButton(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  buttonHeight: 30,
                  onPressed: () {},
                  child: Text(
                    "Ganti",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
