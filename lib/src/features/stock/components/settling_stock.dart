// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/canceling_stock.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
// For detecting web

class SettlingStock extends StatefulWidget with GetItStatefulWidgetMixin {
  SettlingStock({required this.item, super.key});
  final dynamic item;

  @override
  State<SettlingStock> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<SettlingStock> with GetItStateMixin {
  bool _showError = false;
  bool _isFactory = false;

  @override
  void initState() {
    super.initState();
    _showError = false;
    _isFactory = widget.item['stockEvent'] == 'stock_in';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Konfirmasi Pembayaran",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Apakah produk ini: ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item['productName'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${widget.item['amount']} ${widget.item['measurement']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  formatCurrency(_generatePrice(widget.item)),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            _isFactory ? "Telah dibayarkan kepada" : "Telah dibayarkan oleh:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                _isFactory
                    ? "Gracia Factory"
                    : "${widget.item['entityType']}, ${widget.item['relatedEntity']}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _isFactory
                  ? "Pastikan product telah diterima"
                  : "Pastikan pembayaran telah diterima!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.amber.shade900,
              ),
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: GradientElevatedButton(
                  // inactiveDelay: Duration.zero,
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.close, color: Colors.white, size: 20),
                      Text(
                        "Tidak",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30),
              SizedBox(
                width: 120,
                child: GradientElevatedButton(
                  inactiveDelay: Durations.short1,
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: () async {
                    bool success = await get<StockViewModel>().settlingStock(
                      context: context,
                      stockId: widget.item['stockId'],
                      metricId: widget.item['metricId'],
                    );

                    if (success) {
                      Navigator.pushNamed(context, stockRoute);
                    } else {}
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      // SizedBox(width: 5),
                      Text(
                        "Ya",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: 220,
              child: GradientElevatedButton(
                // inactiveDelay: Duration.zero,
                gradient: LinearGradient(
                  colors: [Colors.red.shade300, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    isScrollControlled: true,
                    constraints: BoxConstraints(minHeight: 600, maxHeight: 620),
                    context: context,
                    builder: (context) {
                      return CancelingStock(item: widget.item, isBatch: false);
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isFactory
                          ? "Batalkan Pembelian  "
                          : "Batalkan Penjualan  ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showError)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Terjadi kesalahan di system"),
            ),
        ],
      ),
    );
  }

  double _generatePrice(dynamic mainProduct) {
    switch (mainProduct['entityType']) {
      case "Agent":
        return (mainProduct?['agentPrice'] ?? 0).toDouble();
      case "SubAgent":
        return (mainProduct?['subAgentPrice'] ?? 0).toDouble();
      case "Salesman":
        return (mainProduct?['salesmanPrice'] ?? 0).toDouble();
      default:
        return (mainProduct?['totalPrice'] ?? 0).toDouble();
    }
  }
}
