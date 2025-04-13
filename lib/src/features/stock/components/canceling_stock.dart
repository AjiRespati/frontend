// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
// For detecting web

class CancelingStock extends StatefulWidget with GetItStatefulWidgetMixin {
  CancelingStock({required this.item, required this.isBatch, super.key});
  final dynamic item;
  final bool isBatch;

  @override
  State<CancelingStock> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<CancelingStock>
    with GetItStateMixin {
  bool _showError = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showError = false;
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
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
              "Batalkan Pembelian Stock",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.amber.shade900,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.isBatch
                ? "Apakah anda yakin membatalkan pembelian sebanyak: "
                : "Apakah anda yakin membatalkan pembelian: ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isBatch
                      ? "${widget.item['itemCount']} produk?"
                      : widget.item['productName'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (!widget.isBatch)
                  Text(
                    "${widget.item['amount']} ${widget.item['measurement']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                if (!widget.isBatch)
                  Text(
                    formatCurrency(widget.item['totalNetPrice']),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Text(
            widget.isBatch ? "Dibuat oleh:" : "Kepada:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                widget.isBatch
                    ? "${widget.item['userDesc']}, ${widget.item['createdBy']}"
                    : "${widget.item['entityType']}, ${widget.item['relatedEntity']}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Keterangan (Optional)"),
          ),

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: GradientElevatedButton(
                  // inactiveDelay: Duration.zero,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade700, Colors.red.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                  onPressed: () async {
                    bool? success = await get<StockViewModel>()
                        .cancelStockBatch(batchId: widget.item['id']);

                    if (success == true) {
                      await get<StockViewModel>().getStockBatches(
                        context: context,
                        status: 'completed',
                        sortBy: null,
                        sortOrder: null,
                        page: null,
                        limit: null,
                      );
                      get<StockViewModel>().isBusy = false;
                      Navigator.pop(context);
                    } else {
                      get<StockViewModel>().isBusy = false;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.red.shade400,
                          content: Text(
                            "Konfirmasi pembayaran gagal, hubungi pengembang aplikasi",
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
          if (_showError)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Terjadi kesalahan di system"),
            ),
        ],
      ),
    );
  }
}
