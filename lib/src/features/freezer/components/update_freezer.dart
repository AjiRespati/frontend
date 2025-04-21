// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdateFreezer extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateFreezer({required this.freezer, super.key});
  final Map<String, dynamic> freezer;

  @override
  State<UpdateFreezer> createState() => _UpdateFreezerState();
}

class _UpdateFreezerState extends State<UpdateFreezer> with GetItStateMixin {
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _capacityController = TextEditingController();
  // final TextEditingController _serialNumberController = TextEditingController();
  final ApiService apiService = ApiService();
  dynamic _selectedShop;
  String oldStatus = "IDLE";

  void _submit() async {
    var freezerInfo = widget.freezer;
    var shopInfo = _selectedShop;

    if (oldStatus == "IDLE") {
      bool result = await get<StockViewModel>().returnFreezer(
        context: context,
        id: freezerInfo['id'],
      );

      if (result) {
        await get<StockViewModel>().getAllFrezer(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.red.shade400,
            content: Text("Kesalahan system, gagal update freezer"),
            duration: const Duration(seconds: 3), // Adjust duration as needed
          ),
        );
      }
    } else
    // Hanya update freezer
    if (shopInfo == null) {
      bool result = await ApiService().updateFreezerStatus(
        context: context,
        id: freezerInfo['id'],
        status: oldStatus.toLowerCase(),
        description: null,
      );

      if (result) {
        await get<StockViewModel>().getAllFrezer(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.red.shade400,
            content: Text("Kesalahan system, gagal update freezer"),
            duration: const Duration(seconds: 3), // Adjust duration as needed
          ),
        );
      }
    } else {
      // update freezer dan toko
      bool result = await get<StockViewModel>().updateFreezerShop(
        context: context,
        id: freezerInfo['id'],
        shopId: shopInfo['id'],
        status: oldStatus.toLowerCase(),
      );

      if (result) {
        await get<StockViewModel>().getAllFrezer(context);
        get<StockViewModel>().getAllShops(context: context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.red.shade400,
            content: Text("Kesalahan system, gagal update freezer"),
            duration: const Duration(seconds: 3), // Adjust duration as needed
          ),
        );
      }
    }

    await get<StockViewModel>().getAllFrezer(context);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // print(widget.freezer);
    oldStatus = widget.freezer["status"].toString().toUpperCase();
    _selectedShop = widget.freezer['Shop'];
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shops);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Update Freezer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "${widget.freezer['name']} (${widget.freezer['serialNumber']})",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            "${widget.freezer['status']}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: statusColor(widget.freezer['status']),
            ),
          ),
          SizedBox(height: 15),

          Row(children: [Text("Kirim Freezer ke toko")]),
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
                  hintText: "Cari toko...",
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
              itemBuilder: _customPopupItemBuilder,
            ),
            // *** Core properties (mostly unchanged in how they are used) ***
            items:
                (filter, loadProps) =>
                    get<StockViewModel>().shops, // The list of items
            onChanged: (dynamic newValue) {
              // Callback when an item is selected
              setState(() {
                _selectedShop = newValue;
                // print("Selected shop: $_selectedShop");
              });
            },
            selectedItem: _selectedShop, // The currently selected item
            // *** Optional: Customize the display of the selected item when closed ***
            // This builder is still valid at the top level
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                // Use hint style from decoration if available and item is null
                final hintStyle =
                    Theme.of(context).inputDecorationTheme.hintStyle ??
                    TextStyle(color: Colors.grey[600]);
                return Text("Pilih toko", style: hintStyle);
              }
              return Text(selectedItem['name']);
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
          Row(children: [Text("Update Status Freezer")]),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(isDense: true),
            value: oldStatus,
            items:
                ["IDLE", "ACTIVE", "BROKEN", "REPAIRING", "WASTED"].map((item) {
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
                  "Update Freezer",
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
        item['name'],
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
