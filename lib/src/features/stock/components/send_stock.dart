// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SendStock extends StatefulWidget with GetItStatefulWidgetMixin {
  SendStock({
    required this.measurement,
    required this.mainProduct,
    required this.stockOnHand,
    super.key,
  });

  final dynamic mainProduct;
  final String measurement;
  final int stockOnHand;

  @override
  State<SendStock> createState() => _SendStockState();
}

class _SendStockState extends State<SendStock> with GetItStateMixin {
  bool _insufficientStock = false;

  /// Send stock
  /// 1. pilih jenis client yang dikirim:
  ///     - salesman (fetch salesman)
  ///     - subAgent (fetch subagent)
  ///     - agent    (fetch agent)
  /// 2. pilih client
  /// 3. input jumlah
  /// 4. selesai
  /// 5. lanjutkan proses pembayaran di halaman stock
  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.clientProduct);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: get<StockViewModel>().formKey,
        child: Column(
          children: [
            Text(
              widget.mainProduct?['productName'] ?? "N/A",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            Row(children: [Text("Amount")]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (widget.stockOnHand < (int.tryParse(value) ?? 0)) {
                        setState(() {
                          _insufficientStock = true;
                        });
                      } else {
                        setState(() {
                          _insufficientStock = false;
                        });
                        get<StockViewModel>().stockAmount =
                            int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: Text(widget.measurement)),
                // SizedBox(width: 10),
                Text(
                  "Insufficient Stock",
                  style: TextStyle(
                    color: _insufficientStock ? Colors.red : Colors.transparent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(child: SizedBox()),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
            Row(children: [Text("Stock Event Type")]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.shopping_cart_checkout_rounded,
                        color: Colors.amber,
                        size: 30,
                      ),
                      SizedBox(width: 5),
                      Text('Send Stock'),
                    ],
                  ),
                  // child: DropdownButtonFormField<String>(
                  //   value: get<StockViewModel>().stockEvent,
                  //   items: [
                  //     DropdownMenuItem(
                  //       value: 'stock_in',
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           SizedBox(width: 10),
                  //           Icon(
                  //             Icons.add_circle_outline_rounded,
                  //             color: Colors.green,
                  //             size: 30,
                  //           ),
                  //           SizedBox(width: 5),
                  //           Text('Add Stock'),
                  //         ],
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'stock_out',
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           SizedBox(width: 10),
                  //           Icon(
                  //             Icons.shopping_cart_checkout_rounded,
                  //             color: Colors.amber,
                  //             size: 30,
                  //           ),
                  //           SizedBox(width: 5),
                  //           Text('Send Stock'),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  //   onChanged: (value) {
                  //     get<StockViewModel>().stockEvent = value ?? "stock_in";
                  //   },
                  // ),
                ),
                SizedBox(width: 10),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(height: 10),
                Row(children: [Text("To: ")]),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(isDense: true),
                  value: get<StockViewModel>().clientProduct,
                  items:
                      get<StockViewModel>().clientProducts.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (value) {
                    get<StockViewModel>().salesChoosen = null;
                    get<StockViewModel>().subAgentChoosen = null;
                    get<StockViewModel>().agentChoosen = null;
                    get<StockViewModel>().clientProduct = value ?? "salesman";
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("${get<StockViewModel>().clientProduct} Name: "),
                  ],
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(isDense: true),
                  value:
                      get<StockViewModel>().clientProduct == "salesman"
                          ? get<StockViewModel>().salesChoosen
                          : get<StockViewModel>().clientProduct == 'subAgent'
                          ? get<StockViewModel>().subAgentChoosen
                          : get<StockViewModel>().agentChoosen,
                  items:
                      (get<StockViewModel>().clientProduct == "salesman"
                              ? get<StockViewModel>().salesmanNames
                              : get<StockViewModel>().clientProduct ==
                                  'subAgent'
                              ? get<StockViewModel>().subAgentNames
                              : get<StockViewModel>().agentNames)
                          .map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          })
                          .toList(),
                  onChanged: (value) {
                    get<StockViewModel>().clientProduct == "salesman"
                        ? get<StockViewModel>().salesChoosen = value
                        : get<StockViewModel>().clientProduct == 'subAgent'
                        ? get<StockViewModel>().subAgentChoosen = value
                        : get<StockViewModel>().agentChoosen = value;
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                isDense: true,
              ),
              onChanged: (value) => get<StockViewModel>().description = value,
            ),
            SizedBox(height: 20),
            GradientElevatedButton(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // inactiveDelay: Duration.zero,
              onPressed: () async {
                get<StockViewModel>().metricId =
                    widget.mainProduct?['metricId'];
                get<StockViewModel>().stockEvent = 'stock_out';
                await get<StockViewModel>().createStock(
                  // context: context,
                  isAdmin: true,
                );
                await get<StockViewModel>().fetchProduct(
                  context,
                  widget.mainProduct?['productId'],
                  false,
                );
                get<StockViewModel>().fetchProducts(context);
              },
              child: Text(
                'Send Stock',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
