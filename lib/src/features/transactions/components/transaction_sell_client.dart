// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/transactions/components/buy_product.dart';
import 'package:frontend/src/features/transactions/components/transaction_buy.dart';
import 'package:frontend/src/models/product_transaction.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/buttons/remove_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TransactionSellClient extends StatefulWidget
    with GetItStatefulWidgetMixin {
  TransactionSellClient({super.key});

  @override
  State<TransactionSellClient> createState() => _TransactionSellClientState();
}

class _TransactionSellClientState extends State<TransactionSellClient>
    with GetItStateMixin {
  dynamic _selectedProduct;
  String? _selectedId;
  dynamic _selectedShop;
  String? _selectedShopId;
  dynamic _productDetail;

  String? _selectedMetric;

  _onSelect() async {
    await get<StockViewModel>().fetchProduct(context, _selectedId ?? "-", true);
    List<dynamic>? allProducts = get<StockViewModel>().productsDetail;
    List<dynamic>? allMetrics;
    allMetrics =
        allProducts?.map((e) => e['metricType'].toLowerCase()).toList();

    if (allMetrics != null && allMetrics.length > 1) {
      bool isReturn = await showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: 340),
        context: context,
        builder: (context) {
          return SelectMetric(
            allMetrics: allMetrics,
            onChooseMetric: (metric) {
              _selectedMetric = metric;
            },
          );
        },
      );

      if (isReturn) {
        return;
      }

      var idx = allMetrics.indexOf(_selectedMetric);
      _productDetail = get<StockViewModel>().productsDetail?[idx];
    } else {
      _productDetail = get<StockViewModel>().productsDetail?[0];
    }
    await Future.delayed(Durations.short3);
    // print(_productDetail);
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 540),
      context: context,
      builder: (context) {
        return BuyProduct(
          measurement:
              (_productDetail?['metricType'] ?? "").toString().toLowerCase(),
          mainProduct: _productDetail,
          stockEvent: 'stock_out',
          shopId: _selectedShopId,
        );
      },
    ).then((value) async {
      await Future.delayed(Durations.short1);
      _selectedProduct = null;
      _selectedId = null;
      _productDetail = null;
    });
  }

  _onSelectShop() async {
    get<StockViewModel>().clearNewTransactions(isFromUI: true);
  }

  @override
  void initState() {
    super.initState();
    if (get<SystemViewModel>().level == 6) {
      _selectedShop = {
        "name": get<SystemViewModel>().name,
        "id": get<SystemViewModel>().shopId,
      };
      _selectedShopId = get<SystemViewModel>().shopId;
    }
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.reloadBuy);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text("Pemesanan"),
          Text(formatDateFromYearToDay(DateTime.now())),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(_selectedShop?['name'] ?? " ")],
          ),
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

          Expanded(
            // height: MediaQuery.of(context).size.height - 530,
            child: ListView.builder(
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: get<StockViewModel>().newTransactions.length,
              itemBuilder: (context, index) {
                ProductTransaction item =
                    get<StockViewModel>().newTransactions[index];
                return Card(
                  key: ValueKey(index + 18000),
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

          Divider(),

          SizedBox(height: 5),

          if (get<SystemViewModel>().level != 6)
            Row(children: [Text("Pilih Toko")]),
          if (get<SystemViewModel>().level != 6)
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
                  _selectedShopId = newValue['id'];
                });

                _onSelectShop();
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
                return Text("${selectedItem['name']}");
              },
              filterFn: (item, filter) {
                // Optional: Custom filter logic
                if (filter.isEmpty) {
                  return true;
                } // Show all if search is empty
                // Case-insensitive search
                return item['name'].toLowerCase().contains(
                  filter.toLowerCase(),
                );
              },
              compareFn: (item1, item2) => item1['id' == item2['id']],
            ),
          SizedBox(height: 15),

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
            // inactiveDelay: Duration.zero,
            onPressed: () async {
              if (_selectedShop == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    backgroundColor: Colors.red,
                    content: Text("Toko harus dipilih"),
                    duration: const Duration(
                      seconds: 3,
                    ), // Adjust duration as needed
                  ),
                );
              } else if (get<StockViewModel>().newTransactions.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    backgroundColor: Colors.red,
                    content: Text("Product harus dipilih"),
                    duration: const Duration(
                      seconds: 3,
                    ), // Adjust duration as needed
                  ),
                );
              } else {
                final bool? confirmResult = await showDialog(
                  context: context,
                  builder:
                      (context) => SizedBox(
                        height: 100,
                        child: AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            _selectedShop?['name'] ?? " ",
                            overflow: TextOverflow.ellipsis,
                          ),
                          content: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "Lanjutkan ke pemesanan.\nPastikan data-data sudah benar",
                                  maxLines: 3,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            SizedBox(
                              width: 100,
                              child: GradientElevatedButton(
                                inactiveDelay: Duration.zero,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.lightBlue.shade400,
                                    Colors.blueAccent,
                                  ],
                                ),
                                buttonHeight: 25,
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: GradientElevatedButton(
                                inactiveDelay: Duration.zero,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.greenAccent.shade400,
                                    Colors.greenAccent.shade700,
                                  ],
                                ),
                                buttonHeight: 25,
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text(
                                  'Pesan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                );

                StockViewModel viewModel = get<StockViewModel>();
                // Check result AFTER dialog closes
                if (confirmResult == true) {
                  // Check if widget is still mounted BEFORE starting async work
                  if (!mounted) return;

                  // Assuming 'viewModel' is your instance of StockViewModel
                  // Call the async method and wait for it
                  final bool purchaseSuccess = await viewModel.buyProducts(
                    isAdmin: false,
                  );

                  // IMPORTANT: Check if widget is *still* mounted AFTER the await completes
                  if (!mounted) return;

                  // Show feedback using the widget's context (which is now safe to use)
                  // Get the message from the ViewModel state which was updated
                  final String message =
                      viewModel.submissionStatusMessage.isNotEmpty
                          ? viewModel.submissionStatusMessage
                          : (purchaseSuccess
                              ? 'Success!'
                              : 'Failed!'); // Fallback message

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor:
                          purchaseSuccess ? Colors.green : Colors.red,
                      duration: const Duration(
                        seconds: 2,
                      ), // Adjust duration as needed
                    ),
                  );
                  await Future.delayed(Durations.extralong4);
                  Navigator.pushNamed(context, transactionsRoute);
                }
              }
            },
            child: Text(
              "Buat Pemesanan",
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              item['productName'] ?? item['name'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: textColor, // Use the determined color
                fontWeight: fontWeight, // Use the determined weight
                // decoration: isDisabled ? TextDecoration.lineThrough : null, // Optional: strike-through
              ),
            ),
          ),

          SizedBox(width: 15),
          Text("Stock: "),
          Text(item['totalStock'] == null ? "" : item['totalStock'].toString()),
        ],
      ),
    );
  }
}
