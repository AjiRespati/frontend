// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/transactions/components/buy_product.dart';
import 'package:frontend/src/models/product_transaction.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/buttons/remove_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TransactionBuy extends StatefulWidget with GetItStatefulWidgetMixin {
  TransactionBuy({super.key});

  @override
  State<TransactionBuy> createState() => _TransactionBuyState();
}

class _TransactionBuyState extends State<TransactionBuy> with GetItStateMixin {
  dynamic _selectedProduct;
  String? _selectedId;
  dynamic _productDetail;

  _onSelect() async {
    await get<StockViewModel>().fetchProduct(context, _selectedId ?? "-");

    _productDetail = get<StockViewModel>().productsDetail?[0];

    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 540),
      context: context,
      builder: (context) {
        return BuyProduct(
          measurement: _productDetail['metricType'].toString().toLowerCase(),
          mainProduct: _productDetail,
        );
      },
    ).then((value) async {
      await Future.delayed(Durations.short1);
      _selectedProduct = null;
      _selectedId = null;
      _productDetail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.reloadBuy);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text("Resume Pembelian"),
          Text(formatDateFromYearToDay(DateTime.now())),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 13),
              Text(get<StockViewModel>().sumItems.toString()),
              Text(" items dari "),
              Text(get<StockViewModel>().sumProducts.toString()),
              Text(" product"),
              Spacer(),
              Text("Total: "),
              Text(
                formatCurrency(get<StockViewModel>().sumTransactions),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(width: 13),
            ],
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height - 500,
            child: ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: get<StockViewModel>().newTransactions.length,
              itemBuilder: (context, index) {
                ProductTransaction item =
                    get<StockViewModel>().newTransactions[index];
                return Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Product: ${item.productDetail['productName']}",
                            ),
                            Spacer(),
                            RemoveButton(
                              size: 22,
                              title: "${item.productDetail['productName']}",
                              toolTip:
                                  "Apakah anda yakin akan menghapus product ini?",
                              onPressed: () async {
                                get<StockViewModel>()
                                    .removeProductTransactionById(
                                      item.productDetail['productId'],
                                    );
                                get<StockViewModel>().reloadBuy =
                                    item.productDetail;
                                await Future.delayed(Durations.short1);
                                get<StockViewModel>().reloadBuy = null;
                              },
                            ),
                            // RemoveButton(onPressed: () {}),
                          ],
                        ),
                        Text(
                          "Harga: ${formatCurrency(item.price)} / ${item.productDetail['metricType']}",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jumlah: ${item.productAmount}"),
                            Text(formatCurrency(item.totalPrice)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Spacer(),
          Divider(),

          SizedBox(height: 5),

          Row(children: [Text("Pilih Product")]),
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
                  hintText: "Cari product...",
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
              itemBuilder: _customPopupItemBuilder,
            ),
            // *** Core properties (mostly unchanged in how they are used) ***
            items:
                (filter, loadProps) =>
                    get<StockViewModel>().products, // The list of items
            onChanged: (dynamic newValue) {
              // Callback when an item is selected
              setState(() {
                _selectedProduct = newValue;
                _selectedId = _selectedProduct['productId'];
              });

              _onSelect();
            },
            selectedItem: _selectedProduct, // The currently selected item
            // *** Optional: Customize the display of the selected item when closed ***
            // This builder is still valid at the top level
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                // Use hint style from decoration if available and item is null
                final hintStyle =
                    Theme.of(context).inputDecorationTheme.hintStyle ??
                    TextStyle(color: Colors.grey[600]);
                return Text("Pilih product", style: hintStyle);
              }
              return Text("${selectedItem['productName']}");
            },
            filterFn: (item, filter) {
              // Optional: Custom filter logic
              if (filter.isEmpty) {
                return true;
              } // Show all if search is empty
              // Case-insensitive search
              return item['productName'].toLowerCase().contains(
                filter.toLowerCase(),
              );
            },
            compareFn: (item1, item2) => item1['id' == item2['id']],
          ),
          SizedBox(height: 15),
          GradientElevatedButton(
            onPressed: () async {
              await get<StockViewModel>().buyProducts(context: context);
              get<StockViewModel>().reloadBuy = "reload";
              await Future.delayed(Durations.short1);
              get<StockViewModel>().reloadBuy = null;
            },
            child: Text(
              "Buat Pembelian",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5),
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
        item['productName'],
        style: TextStyle(
          fontSize: 16,
          color: textColor, // Use the determined color
          fontWeight: fontWeight, // Use the determined weight
          // decoration: isDisabled ? TextDecoration.lineThrough : null, // Optional: strike-through
        ),
      ),
    );
  }
}
