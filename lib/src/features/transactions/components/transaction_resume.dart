// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/canceling_stock.dart';
import 'package:frontend/src/features/transactions/components/resume_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TransactionResume extends StatefulWidget with GetItStatefulWidgetMixin {
  TransactionResume({super.key});

  @override
  State<TransactionResume> createState() => _TransactionResumeState();
}

class _TransactionResumeState extends State<TransactionResume>
    with GetItStateMixin {
  String? _selectedStatus = 'all';
  String _messageSuccess = "";
  String _messageError = "";
  bool isClient = true;

  @override
  void initState() {
    super.initState();

    isClient =
        (get<SystemViewModel>().level ?? 0) < 4 ||
        (get<SystemViewModel>().level ?? 0) > 5;
  }

  _handleBatchActions(Map<String, dynamic> stock, double totalPrice) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(minHeight: 600, maxHeight: 620),
      context: context,
      builder: (context) {
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
                "Apakah pembayaran senilai: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 3, bottom: 3),
                child: Text(
                  formatCurrency(totalPrice),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
              if (stock['Stocks']?[0]?['stockEvent'] == 'stock_in')
                Row(
                  children: [
                    Text(
                      "Kepada ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Gracia Factory",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              if (stock['Stocks']?[0]?['stockEvent'] == 'stock_out')
                Row(
                  children: [
                    Text("Oleh ", style: TextStyle(fontSize: 16)),
                    Text(
                      "${stock['userDesc']}:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "${stock['createdBy']}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Telah dilakukan?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Pastikan pembayaran telah dilakukan!",
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
                        bool? result = await get<StockViewModel>()
                            .settleStockBatch(batchId: stock['id']);

                        if (result == true) {
                          await get<StockViewModel>().getStockBatches(
                            context: context,
                            isClient: isClient,
                            status: 'all',
                            level: get<SystemViewModel>().level,
                            shopId: get<SystemViewModel>().shopId,
                            parentId: get<SystemViewModel>().shopParentId,
                            parentType: get<SystemViewModel>().shopParentType,
                            sortBy: null,
                            sortOrder: null,
                            page: null,
                            limit: null,
                          );
                          _messageSuccess = "Konfirmasi pembayaran berhasil.";
                          _messageError = "";
                          get<StockViewModel>().reloadBuy = false;
                          get<StockViewModel>().isBusy = false;
                          get<StockViewModel>().reloadBuy = null;
                          Navigator.pop(context);
                        } else {
                          _messageSuccess = "";
                          _messageError =
                              "Konfirmasi pembayaran gagal, hubungi pengembang aplikasi";
                          get<StockViewModel>().reloadBuy = false;
                          get<StockViewModel>().isBusy = false;
                          get<StockViewModel>().reloadBuy = null;
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
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
                        constraints: BoxConstraints(
                          minHeight: 600,
                          maxHeight: 620,
                        ),
                        context: context,
                        builder: (context) {
                          return CancelingStock(item: stock, isBatch: true);
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Batalkan ",
                          // _isFactory
                          //     ? "Batalkan Pembelian  "
                          //     : "Batalkan Penjualan  ",
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
            ],
          ),
        );
      },
    );

    if (_messageSuccess.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.green.shade400,
          content: Text(_messageSuccess, style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 2),
        ),
      );
      _messageSuccess = "";
    }

    if (_messageError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade400,
          content: Text(_messageError, style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 2),
        ),
      );
      _messageError = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.reloadBuy);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDatePicker(
                    context,
                    "From: ",
                    get<StockViewModel>().dateFromFilter,
                    (date) {
                      get<StockViewModel>().dateFromFilter = date;
                    },
                  ),

                  _buildDatePicker(
                    context,
                    "To: ",
                    get<StockViewModel>().dateToFilter,
                    (date) {
                      get<StockViewModel>().dateToFilter = date;
                    },
                  ),
                  SizedBox(
                    width: 50,
                    child: GradientElevatedButton(
                      padding: EdgeInsets.zero,
                      buttonHeight: 34,
                      onPressed: () {
                        get<StockViewModel>().getStockBatches(
                          context: context,
                          isClient: isClient,
                          status: _selectedStatus ?? "all",
                          shopId: get<SystemViewModel>().shopId,
                          level: get<SystemViewModel>().level,
                          parentId: get<SystemViewModel>().shopParentId,
                          parentType: get<SystemViewModel>().shopParentType,
                          sortBy: null,
                          sortOrder: null,
                          page: null,
                          limit: null,
                        );
                      },
                      child: Icon(Icons.search, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
              if (get<StockViewModel>().isBusy)
                Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 60),
          child: Row(
            children:
                ['all', 'completed'].map((status) {
                  return Flexible(
                    child: RadioListTile<String>(
                      dense: true,
                      radioScaleFactor: 0.8,
                      activeColor: Colors.blue.shade700,
                      contentPadding: EdgeInsets.zero,
                      title: Badge.count(
                        smallSize: 10,
                        largeSize: 18,
                        isLabelVisible:
                            status == 'completed' &&
                            watchOnly((StockViewModel x) => x.batchCompleted) >
                                0,
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        count: watchOnly(
                          (StockViewModel x) => x.batchCompleted,
                        ),
                        child: Text(status.toUpperCase()),
                      ),
                      value: status,
                      groupValue: _selectedStatus,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                        get<StockViewModel>().getStockBatches(
                          context: context,
                          isClient: isClient,
                          status: _selectedStatus ?? "all",
                          level: get<SystemViewModel>().level,
                          shopId: get<SystemViewModel>().shopId,
                          parentId: get<SystemViewModel>().shopParentId,
                          parentType: get<SystemViewModel>().shopParentType,
                          sortBy: null,
                          sortOrder: null,
                          page: null,
                          limit: null,
                        );
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child:
                watchOnly((StockViewModel x) => x.responseBatch).isEmpty
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Text("Tidak ada stok pada tanggal dipilih."),
                        ),
                      ],
                    )
                    : Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 10,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: get<StockViewModel>().responseBatch.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> stock =
                              get<StockViewModel>().responseBatch[index];

                          int level =
                              stock['userDesc'] == 'Salesman'
                                  ? 1
                                  : stock['userDesc'] == 'Sub Agent'
                                  ? 2
                                  : stock['userDesc'] == 'Agent'
                                  ? 3
                                  : 4;

                          List<dynamic> stocks = stock['Stocks'];
                          double totalPrice = _generateTotalPrice(
                            stocks,
                            level,
                          );
                          int totalProduct = _generateTotalProduct(stocks);
                          int totalItem = _generateTotalItem(stocks);

                          return ResumeCard(
                            stock: stock,
                            totalProduct: totalProduct,
                            totalItem: totalItem,
                            totalPrice: totalPrice,
                            stocks: stocks,
                            onSelect: () {
                              if (!isClient &&
                                  (stock['status'] == 'completed')) {
                                _handleBatchActions(stock, totalPrice);
                              }
                            },
                          );
                        },
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: () async {
          DateTime? pickedDate = await showCustomDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
          );
          // );
          if (pickedDate != null) onDateSelected(pickedDate);
        },
        child: Text(
          label + (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
        ),
      ),
    );
  }

  double _generateTotalPrice(List<dynamic> stocks, int level) {
    double totalPrice = 0;
    switch (level) {
      case 5:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['totalPrice'] ?? 0)),
        );
        break;
      case 4:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['totalPrice'] ?? 0)),
        );
        break;
      case 3:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['agentPrice'] ?? 0)),
        );
        break;
      case 2:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['subAgentPrice'] ?? 0)),
        );
        break;
      case 1:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['salesmanPrice'] ?? 0)),
        );
        break;
      default:
        totalPrice = stocks.fold<double>(
          0,
          (sum, item) => sum + ((item['shopPrice'] ?? 0)),
        );
        break;
    }

    return totalPrice;
  }

  int _generateTotalProduct(List<dynamic> stocks) {
    return stocks.length;
  }

  int _generateTotalItem(List<dynamic> stocks) {
    return stocks.fold<int>(
      0,
      (sum, item) => sum + ((item['amount'] ?? 0) as int),
    );
  }
}
