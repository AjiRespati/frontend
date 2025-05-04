// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/models/product_transaction.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class StockViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isBusy = false;
  // bool _isLoading = true;
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _commissionData;
  List<dynamic>? _clientCommissionData;
  List<dynamic> _products = [];
  List<dynamic>? _productsDetail;
  List<dynamic> _salesmen = [];
  List<dynamic> _subAgents = [];
  List<dynamic> _agents = [];
  List<String> _salesmanNames = [];
  List<String> _subAgentNames = [];
  List<String> _agentNames = [];
  String? _salesChoosen;
  String? _subAgentChoosen;
  String? _agentChoosen;

  dynamic _stock;
  List<dynamic> _stockTable = [];
  List<dynamic> _stockOnProgressTable = [];
  List<dynamic> _stockOnCanceledTable = [];
  List<dynamic> _stockHistoryTable = [];
  dynamic _stockResume;
  List<dynamic> _salesStockTable = [];
  List<dynamic> _subAgentStockTable = [];
  List<dynamic> _agentStockTable = [];
  List<dynamic> _shopStockTable = [];
  double _totalSettled = 0.0;
  double _totalOnProgress = 0.0;
  double _totalOnCanceled = 0.0;

  // DateTime _dateFromFilter = DateTime.now().subtract(Duration(days: 7));
  // DateTime _dateToFilter = DateTime.now();
  DateTime _dateFromFilter = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime _dateToFilter = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  ).subtract(Duration(days: 1));
  String? _choosenMetricId;

  String? _metricId;
  String _stockEvent = 'stock_in';
  String _measurement = "";
  List<String> measurements = ApplicationInfo.measurements;
  List<String> _availableMeasurement = [];
  int _price = 0;

  List<ProductTransaction> _newTransactions = [];
  double _sumTransactions = 0;
  int _sumProducts = 0;
  int _sumItems = 0;
  dynamic _reloadBuy;

  List<dynamic> _responseBatch = [];

  String _client = 'salesman';
  final List<String> _clients = [
    'salesman',
    'subAgent',
    "agent",
    "admin",
    "owner",
  ];
  String? _clientProduct;
  final List<String> _clientProducts = [
    'all',
    'distributor',
    'salesman',
    'subAgent',
    "agent",
  ];
  String? _createdBy;
  int _stockAmount = 0;
  String? _salesId;
  String? _subAgentId;
  String? _agentId;
  String? _shopId;
  String _status = 'created';
  String? _description;
  int _clientTabIndex = 0;
  int _stockTabIndex = 0;

  List<dynamic> _shops = [];
  List<dynamic> _freezers = [];
  List<dynamic> _idleFreezers = [];

  List<dynamic> _percentages = [];

  //====================//
  //  GETTER n SETTER   //
  //====================//

  String? get choosenMetricId => _choosenMetricId;
  set choosenMetricId(String? val) {
    _choosenMetricId = val;
    notifyListeners();
  }

  String? get metricId => _metricId;
  set metricId(String? val) {
    _metricId = val;
    notifyListeners();
  }

  String get stockEvent => _stockEvent;
  set stockEvent(String val) {
    _stockEvent = val;
    notifyListeners();
  }

  String get measurement => _measurement;
  set measurement(String val) {
    _measurement = val;
    notifyListeners();
  }

  List<String> get availableMeasurement => _availableMeasurement;
  set availableMeasurement(List<String> val) {
    _availableMeasurement = val;
    notifyListeners();
  }

  List<ProductTransaction> get newTransactions => _newTransactions;
  set newTransactions(List<ProductTransaction> val) {
    _newTransactions = val;
    notifyListeners();
  }

  List<dynamic> get responseBatch => _responseBatch;
  set responseBatch(List<dynamic> val) {
    _responseBatch = val;
    notifyListeners();
  }

  dynamic get reloadBuy => _reloadBuy;
  set reloadBuy(dynamic val) {
    _reloadBuy = val;
    notifyListeners();
  }

  double get sumTransactions => _sumTransactions;
  set sumTransactions(double val) {
    _sumTransactions = val;
    notifyListeners();
  }

  int get sumProducts => _sumProducts;
  set sumProducts(int val) {
    _sumProducts = val;
    notifyListeners();
  }

  int get sumItems => _sumItems;
  set sumItems(int val) {
    _sumItems = val;
    notifyListeners();
  }

  String get client => _client;
  set client(String val) {
    _client = val;
    notifyListeners();
  }

  List<String> get clients => _clients;

  String? get clientProduct => _clientProduct;
  set clientProduct(String? val) {
    _clientProduct = val;
    notifyListeners();
  }

  List<String> get clientProducts => _clientProducts;

  String? get createdBy => _createdBy;
  set createdBy(String? val) {
    _createdBy = val;
    notifyListeners();
  }

  int get stockAmount => _stockAmount;
  set stockAmount(int val) {
    _stockAmount = val;
    notifyListeners();
  }

  int get price => _price;
  set price(int val) {
    _price = val;
    notifyListeners();
  }

  String? get salesId => _salesId;
  set salesId(String? val) {
    _salesId = val;
    notifyListeners();
  }

  String? get subAgentId => _subAgentId;
  set subAgentId(String? val) {
    _subAgentId = val;
    notifyListeners();
  }

  String? get agentId => _agentId;
  set agentId(String? val) {
    _agentId = val;
    notifyListeners();
  }

  String? get shopId => _shopId;
  set shopId(String? val) {
    _shopId = val;
    notifyListeners();
  }

  String get status => _status;
  set status(String val) {
    _status = val;
    notifyListeners();
  }

  String? get description => _description;
  set description(String? val) {
    _description = val;
    notifyListeners();
  }

  int get clientTabIndex => _clientTabIndex;
  set clientTabIndex(int val) {
    _clientTabIndex = val;
    notifyListeners();
  }

  int get stockTabIndex => _stockTabIndex;
  set stockTabIndex(int val) {
    _stockTabIndex = val;
    notifyListeners();
  }

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  // bool get isLoading => _isLoading;
  // set isLoading(bool val) {
  //   _isLoading = val;
  //   notifyListeners();
  // }

  Map<String, dynamic>? get commissionData => _commissionData;
  set commissionData(Map<String, dynamic>? val) {
    _commissionData = val;
    notifyListeners();
  }

  List<dynamic>? get clientCommissionData => _clientCommissionData;
  set clientCommissionData(List<dynamic>? val) {
    _clientCommissionData = val;
    notifyListeners();
  }

  List<dynamic> get products => _products;
  set products(List<dynamic> val) {
    _products = val;
    notifyListeners();
  }

  List<dynamic>? get productsDetail => _productsDetail;
  set productsDetail(List<dynamic>? val) {
    _productsDetail = val;
    notifyListeners();
  }

  List<dynamic> get salesmen => _salesmen;
  set salesmen(List<dynamic> val) {
    _salesmen = val;
    notifyListeners();
  }

  List<dynamic> get subAgents => _subAgents;
  set subAgents(List<dynamic> val) {
    _subAgents = val;
    notifyListeners();
  }

  List<dynamic> get agents => _agents;
  set agents(List<dynamic> val) {
    _agents = val;
    notifyListeners();
  }

  List<String> get salesmanNames => _salesmanNames;
  set salesmanNames(List<String> val) {
    _salesmanNames = val;
    notifyListeners();
  }

  List<String> get subAgentNames => _subAgentNames;
  set subAgentNames(List<String> val) {
    _subAgentNames = val;
    notifyListeners();
  }

  List<String> get agentNames => _agentNames;
  set agentNames(List<String> val) {
    _agentNames = val;
    notifyListeners();
  }

  String? get salesChoosen => _salesChoosen;
  set salesChoosen(String? val) {
    _salesChoosen = val;
    notifyListeners();
  }

  String? get subAgentChoosen => _subAgentChoosen;
  set subAgentChoosen(String? val) {
    _subAgentChoosen = val;
    notifyListeners();
  }

  String? get agentChoosen => _agentChoosen;
  set agentChoosen(String? val) {
    _agentChoosen = val;
    notifyListeners();
  }

  dynamic get stock => _stock;
  set stock(dynamic val) {
    _stock = val;
    notifyListeners();
  }

  List<dynamic> get stockOnProgressTable => _stockOnProgressTable;
  set stockOnProgressTable(List<dynamic> val) {
    _stockOnProgressTable = val;
    notifyListeners();
  }

  List<dynamic> get stockOnCanceledTable => _stockOnCanceledTable;
  set stockOnCanceledTable(List<dynamic> val) {
    _stockOnCanceledTable = val;
    notifyListeners();
  }

  List<dynamic> get stockTable => _stockTable;
  set stockTable(List<dynamic> val) {
    _stockTable = val;
    notifyListeners();
  }

  List<dynamic> get stockHistoryTable => _stockHistoryTable;
  set stockHistoryTable(List<dynamic> val) {
    _stockHistoryTable = val;
    notifyListeners();
  }

  dynamic get stockResume => _stockResume;
  set stockResume(dynamic val) {
    _stockResume = val;
    notifyListeners();
  }

  List<dynamic> get salesStockTable => _salesStockTable;
  set salesStockTable(List<dynamic> val) {
    _salesStockTable = val;
    notifyListeners();
  }

  List<dynamic> get subAgentStockTable => _subAgentStockTable;
  set subAgentStockTable(List<dynamic> val) {
    _subAgentStockTable = val;
    notifyListeners();
  }

  List<dynamic> get agentStockTable => _agentStockTable;
  set agentStockTable(List<dynamic> val) {
    _agentStockTable = val;
    notifyListeners();
  }

  List<dynamic> get shopStockTable => _shopStockTable;
  set shopStockTable(List<dynamic> val) {
    _shopStockTable = val;
    notifyListeners();
  }

  double get totalSettled => _totalSettled;
  set totalSettled(double val) {
    _totalSettled = val;
    notifyListeners();
  }

  double get totalOnProgress => _totalOnProgress;
  set totalOnProgress(double val) {
    _totalOnProgress = val;
    notifyListeners();
  }

  double get totalOnCanceled => _totalOnCanceled;
  set totalOnCanceled(double val) {
    _totalOnCanceled = val;
    notifyListeners();
  }

  DateTime get dateFromFilter => _dateFromFilter;
  set dateFromFilter(DateTime val) {
    _dateFromFilter = val;
    notifyListeners();
  }

  DateTime get dateToFilter => _dateToFilter;
  set dateToFilter(DateTime val) {
    _dateToFilter = val;
    notifyListeners();
  }

  List<dynamic> get shops => _shops;
  set shops(List<dynamic> val) {
    _shops = val;
    notifyListeners();
  }

  List<dynamic> get freezers => _freezers;
  set freezers(List<dynamic> val) {
    _freezers = val;
    notifyListeners();
  }

  List<dynamic> get idleFreezers => _idleFreezers;
  set idleFreezers(List<dynamic> val) {
    _idleFreezers = val;
    notifyListeners();
  }

  List<dynamic> get percentages => _percentages;
  set percentages(List<dynamic> val) {
    _percentages = val;
    notifyListeners();
  }

  //====================//
  //       METHOD       //
  //====================//

  fetchCommissionData({required BuildContext context}) async {
    isBusy = true;
    commissionData = null;
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));
    final data = await apiService.fetchCommissionSummary(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
    );

    isBusy = false;
    commissionData = data;
  }

  fetchClientCommissionData({
    required BuildContext context,
    required String id,
    required String clientType,
  }) async {
    isBusy = true;
    clientCommissionData = null;
    final data = await apiService.fetchClientCommission(
      context: context,
      id: id,
      clientType: clientType,
      startDate: generateDateString(dateFromFilter),
      endDate: generateDateString(dateToFilter.add(Duration(days: 1))),
    );

    isBusy = false;
    clientCommissionData = data;
  }

  fetchProducts(BuildContext context) async {
    isBusy = true;
    products = [];
    // List<dynamic> datas = await apiService.fetchProducts(context);
    // Set<String> productIds = {};
    // List<dynamic> data = [];

    // for (var el in datas) {
    //   if (productIds.add(el['productId'])) {
    //     data.add(el);
    //   }
    // }
    // products = data;

    products = await apiService.fetchProducts(context);
    isBusy = false;
  }

  Future<dynamic> fetchProduct(
    BuildContext context,
    String productId,
    bool isBuying,
  ) async {
    isBusy = true;
    productsDetail = [];
    dynamic data = await apiService.fetchProduct(context, productId);
    productsDetail = data;
    List<String> usedMetric = [];
    if (productsDetail != null) {
      for (var i = 0; i < productsDetail!.length; i++) {
        var item = productsDetail![i];
        usedMetric.add(item['metricType']);
      }
      if (!isBuying) {
        List<String> measurementLeft =
            measurements
                .where((measurement) => !usedMetric.contains(measurement))
                .toList();
        measurement = measurementLeft.isEmpty ? "" : measurementLeft.first;
        availableMeasurement = measurementLeft;
      }
    }

    isBusy = false;
    return;
  }

  Future<bool> updatePrice(
    BuildContext context,
    String productId,
    String priceId,
    double price,
  ) async {
    return await apiService.updatePrice(
      context: context,
      priceId: priceId,
      price: price,
    );
  }

  Future<bool> removeProduct({
    required BuildContext context,
    required String productId,
    required String? name,
    required String? status,
    required String? description,
  }) async {
    return await apiService.updateProduct(
      context: context,
      productId: productId,
      name: name,
      description: description,
      status: status,
    );
  }

  /// Generate client id by client choosen name
  _generateClientId() {
    switch (client) {
      case 'salesman':
        for (var el in salesmen) {
          if (salesChoosen == el['name']) {
            salesId = el['id'];
          }
        }
        subAgentId = null;
        agentId = null;
        break;
      case 'subAgent':
        for (var el in subAgents) {
          if (subAgentChoosen == el['name']) {
            subAgentId = el['id'];
          }
        }
        salesId = null;
        agentId = null;
        break;
      default:
        for (var el in agents) {
          if (agentChoosen == el['name']) {
            agentId = el['id'];
          }
        }
        salesId = null;
        subAgentId = null;
    }
  }

  //TODO: Jual Beli stock.
  Future<void> createStock({
    // required BuildContext context,
    required bool isAdmin,
  }) async {
    try {
      isBusy = true;
      if (stockEvent == 'stock_out') {
        if (isAdmin) {
          _generateClientId();
        }
      } else {
        salesId = null;
        subAgentId = null;
        agentId = null;
      }

      final resp = await apiService.createStock(
        // context: context,
        metricId: metricId,
        stockEvent: stockEvent,
        amount: stockAmount,
        salesId: salesId,
        subAgentId: subAgentId,
        agentId: agentId,
        shopId: shopId,
        status: status,
        description: description,
      );

      if (resp) {
        isBusy = false;
      } else {
        isBusy = false;
      }
    } catch (e) {
      print(e);
      isBusy = false;
    }
  }

  Future<void> createMetric({
    required BuildContext context,
    required String productId,
    required String metricType,
    required double price,
  }) async {
    isBusy = true;

    final resp = await apiService.createMetric(
      context,
      productId,
      metricType,
      price,
    );

    if (resp) {
      isBusy = false;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Stock created successfully')));
    } else {
      isBusy = false;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Failed to create stock')));
    }
  }

  Future<dynamic> fetchStockByProduct(
    BuildContext context,
    String productId,
  ) async {
    isBusy = true;
    stock = null;
    stock = await apiService.fetchStockByProduct(context, productId);
    isBusy = false;
    return;
  }

  fetchSalesmen({required bool isInitial, required String? status}) async {
    isBusy = true;
    salesmen = [];
    salesmanNames = [];

    salesmen = await apiService.getSalesmen(status: status);
    List<String> names = [];
    for (var element in salesmen) {
      names.add(element['name']);
    }
    salesmanNames = names;

    if (!isInitial) {
      clientTabIndex = 0;
    } else {
      clientTabIndex = 0;
    }
    isBusy = false;
    return;
  }

  fetchSubAgents({
    required BuildContext context,
    required bool isInitial,
    required String? status,
  }) async {
    isBusy = true;
    subAgents = [];
    subAgentNames = [];

    subAgents = await apiService.getSubAgents(context, status);
    List<String> names = [];
    for (var element in subAgents) {
      names.add(element['name']);
    }
    subAgentNames = names;

    if (!isInitial) {
      clientTabIndex = 1;
    } else {
      clientTabIndex = 0;
    }
    isBusy = false;
    return;
  }

  fetchAgents({
    required BuildContext context,
    required String? status,
    required bool isInitial,
  }) async {
    isBusy = true;
    agents = [];
    agentNames = [];

    agents = await apiService.getAgents(context, status);
    List<String> names = [];
    for (var element in agents) {
      names.add(element['name']);
    }
    agentNames = names;
    if (!isInitial) {
      clientTabIndex = 2;
    } else {
      clientTabIndex = 0;
    }
    isBusy = false;
    return;
  }

  Future<bool> getStockTable({
    required BuildContext context,
    required String status,
    required bool isClient,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String? stockEvent,
  }) async {
    isBusy = true;
    stockTable = [];
    stockOnProgressTable = [];
    stockOnCanceledTable = [];

    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    List<dynamic> response = [];

    if (isClient) {
      response = await apiService.getStockClientTable(
        context: context,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
        agentId: agentId,
        subAgentId: subAgentId,
        salesId: salesId,
        stockEvent: stockEvent,
      );
    } else {
      if (status == 'created') {
        response = await apiService.getStockClientTable(
          context: context,
          fromDate: fromDate,
          toDate: toDate,
          status: status,
          agentId: agentId,
          subAgentId: subAgentId,
          salesId: salesId,
          stockEvent: stockEvent,
        );
      } else {
        response = await apiService.getStockTable(
          context: context,
          fromDate: fromDate,
          toDate: toDate,
          status: status,
          agentId: agentId,
          subAgentId: subAgentId,
          salesId: salesId,
        );
      }
    }

    switch (status) {
      case 'settled':
        totalSettled = 0;
        for (var el in response) {
          var price =
              (el?['agentPrice'] ?? 0) > 0
                  ? el['agentPrice']
                  : (el?['subAgentPrice'] ?? 0) > 0
                  ? el['subAgentPrice']
                  : (el?['salesmanPrice'] ?? 0) > 0
                  ? el['salesmanPrice']
                  : (el?['totalPrice'] ?? 0);
          totalSettled += price;
        }

        stockTable = response;

        break;
      case 'created':
        totalOnProgress = 0;
        for (var el in response) {
          double price =
              (el?['agentPrice'] ?? 0) > 0
                  ? el['agentPrice'].toDouble()
                  : (el?['subAgentPrice'] ?? 0) > 0
                  ? el['subAgentPrice'].toDouble()
                  : (el?['salesmanPrice'] ?? 0) > 0
                  ? el['salesmanPrice'].toDouble()
                  : (el?['totalPrice'] ?? 0).toDouble();
          totalOnProgress += price;
        }

        stockOnProgressTable = response;

        break;
      default:
        totalOnCanceled = 0;
        for (var el in response) {
          var price =
              (el?['agentPrice'] ?? 0) > 0
                  ? el['agentPrice']
                  : (el?['subAgentPrice'] ?? 0) > 0
                  ? el['subAgentPrice']
                  : (el?['salesmanPrice'] ?? 0) > 0
                  ? el['salesmanPrice']
                  : (el?['totalPrice'] ?? 0);
          totalOnCanceled += price;
        }

        stockOnCanceledTable = response;
    }

    isBusy = false;
    return true;
  }

  Future<bool> settlingStock({
    required BuildContext context,
    required String stockId,
    required String metricId,
  }) async {
    isBusy = true;

    bool response = await apiService.settlingStock(
      context: context,
      stockId: stockId,
      metricId: metricId,
    );
    isBusy = false;

    return response;
  }

  Future<bool> cancelingStock({
    required BuildContext context,
    required String stockId,
    required String description,
  }) async {
    isBusy = true;

    bool response = await apiService.cancelingStock(
      context: context,
      stockId: stockId,
      description: description,
    );
    isBusy = false;

    return response;
  }

  Future<bool> getStockHistory({
    required BuildContext context,
    required String status,
  }) async {
    isBusy = true;
    stockHistoryTable = [];
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    stockHistoryTable = await apiService.getStockHistoryTable(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      metricId: choosenMetricId ?? "",
      status: status,
    );

    isBusy = false;
    return true;
  }

  Future<bool> getStockResume({
    required BuildContext context,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String? shopId,
  }) async {
    isBusy = true;
    stockResume = null;
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    stockResume = await apiService.getStockResume(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      salesId: salesId,
      subAgentId: subAgentId,
      agentId: agentId,
      shopId: shopId,
    );

    isBusy = false;
    return true;
  }

  Future<bool> getTableBySalesId({
    required BuildContext context,
    required String salesId,
  }) async {
    isBusy = true;
    salesStockTable = [];
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    salesStockTable = await apiService.getTableBySalesId(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      salesId: salesId,
    );

    // print(salesStockTable);

    isBusy = false;
    return true;
  }

  Future<bool> getTableBySubAgentId({
    required BuildContext context,
    required String subAgentId,
  }) async {
    isBusy = true;
    subAgentStockTable = [];
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    subAgentStockTable = await apiService.getTableBySubAgentId(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      subAgentId: subAgentId,
    );

    // print(salesStockTable);

    isBusy = false;
    return true;
  }

  Future<bool> getTableByAgentId({
    required BuildContext context,
    required String agentId,
  }) async {
    isBusy = true;
    salesStockTable = [];
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    agentStockTable = await apiService.getTableByAgentId(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      agentId: agentId,
    );

    // print(salesStockTable);

    isBusy = false;
    return true;
  }

  Future<bool> getTableByShopId({
    required BuildContext context,
    required String shopId,
  }) async {
    isBusy = true;
    shopStockTable = [];
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    shopStockTable = await apiService.getTableByShopId(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      shopId: shopId,
    );

    // print(salesStockTable);

    isBusy = false;
    return true;
  }

  Future<bool> createShop({
    required BuildContext context,
    required String? salesId,
    required String? subAgentId,
    required String? agentId,
    required String name,
    required String address,
    required String phone,
    required String? email,
    required String? imageUrl,
    required String? coordinates,
  }) async {
    isBusy = true;
    final resp = await apiService.createShop(
      context: context,
      salesId: salesId,
      subAgentId: subAgentId,
      agentId: agentId,
      name: name,
      address: address,
      phone: phone,
      email: email,
      imageUrl: imageUrl,
      coordinates: coordinates,
    );

    if (resp) {
      isBusy = false;
      return true;
    } else {
      isBusy = false;
      return false;
    }
  }

  Future<bool> getShopsBySales({
    required BuildContext context,
    required String salesId,
    bool? isActive,
  }) async {
    isBusy = true;
    shops = [];

    shops = await apiService.getAllShopsBySales(
      context: context,
      salesId: salesId,
    );

    if (isActive == true) {
      shops.removeWhere((shop) {
        // The test function: return true if the item should be removed
        return shop['status'] == 'inactive';
      });
    }

    isBusy = false;
    return true;
  }

  Future<bool> getAllShops({required BuildContext context}) async {
    isBusy = true;
    shops = [];

    shops = await apiService.getAllShops(context: context);
    // print(shops.first);
    isBusy = false;
    return true;
  }

  Future<bool> updateShop({
    required BuildContext context,
    required String? id,
    required String? name,
    required String? image,
    required String? address,
    required String? coordinates,
    required String? phone,
    required String? email,
    required String? status,
  }) async {
    return await apiService.updateShop(
      context: context,
      id: id,
      name: name,
      image: image,
      address: address,
      coordinates: coordinates,
      phone: phone,
      email: email,
      status: status,
    );
  }

  // { name, capacity, serialNumber, coordinates, shopId, status, deliveryDate, deliveryBy }
  Future<bool> addRefrigerator({
    required BuildContext context,
    required String name,
    required String capacity,
    required String serialNumber,
    required String? coordinates,
  }) async {
    isBusy = true;
    final resp = await apiService.addFrezer(
      context: context,
      name: name,
      capacity: capacity,
      serialNumber: serialNumber,
      coordinates: coordinates,
    );

    if (resp) {
      isBusy = false;
      return true;
    } else {
      isBusy = false;
      return false;
    }
  }

  Future<bool> getAllFrezer(BuildContext context) async {
    isBusy = true;
    freezers = [];
    idleFreezers = [];

    freezers = await apiService.getAllFreezer(context);

    idleFreezers = freezers.where((el) => el['status'] == 'idle').toList();
    isBusy = false;

    return true;
  }

  Future<bool> updateFreezerShop({
    required BuildContext context,
    required String id,
    required String shopId,
    required String status,
  }) async {
    return await apiService.updateFreezerShop(
      context: context,
      id: id,
      shopId: shopId,
      status: status,
    );
  }

  Future<bool> returnFreezer({
    required BuildContext context,
    required String id,
  }) async {
    return await apiService.returnFreezer(context: context, id: id);
  }

  Future<bool> updateFreezerStatus({
    required BuildContext context,
    required String id,
    required String status,
    required String? description,
  }) async {
    return await apiService.updateFreezerStatus(
      context: context,
      id: id,
      status: status,
      description: description,
    );
  }

  addProductTransaction(ProductTransaction val) {
    // Find the index of an existing transaction with the same productId
    // Returns -1 if no matching element is found.
    int existingIndex = _newTransactions.indexWhere(
      (el) =>
          ((el.productId == val.productId) &&
              (el.productDetail['metricType'] ==
                  val.productDetail['metricType'])),
    );

    if (existingIndex != -1) {
      // --- Product already exists: Update the existing transaction ---
      // Get the item at the found index
      ProductTransaction existingItem = _newTransactions[existingIndex];

      // Update the amount and total price of the EXISTING item
      existingItem.productAmount += val.productAmount; // Use += for clarity
      existingItem.totalPrice += val.totalPrice; // Use += for clarity

      // Update overall summaries ONLY with the amounts from the *newly added portion* (val)
      _sumTransactions += val.totalPrice;
      _sumItems += val.productAmount;
      // _sumProducts (number of unique lines) doesn't change here
    } else {
      // --- Product does not exist: Add the new transaction ---
      _newTransactions.add(val);

      // Update overall summaries with the amounts from the *new* transaction (val)
      _sumTransactions += val.totalPrice;
      _sumItems += val.productAmount;
      // _sumProducts (number of unique lines) increases because we added a new line
      // This will be updated below based on final list length.
    }
    // Update the total product count (number of lines in the transaction list)
    // This should reflect the number of unique products added so far.
    _sumProducts = _newTransactions.length;
    notifyListeners();
  }

  void removeProductTransactionById(String productIdToRemove) async {
    // Find the index of the item with the matching productId
    int indexToRemove = _newTransactions.indexWhere(
      (el) => el.productId == productIdToRemove,
    );

    // Proceed only if an item with that ID was found (index is not -1)
    if (indexToRemove != -1) {
      // Get the item *before* removing it to access its values for subtraction
      ProductTransaction itemBeingRemoved = _newTransactions[indexToRemove];

      // Subtract its values from the summaries
      _sumTransactions -= itemBeingRemoved.totalPrice;
      _sumItems -= itemBeingRemoved.productAmount;

      // Remove the item from the list using its index
      _newTransactions.removeAt(indexToRemove);

      // Update the count of unique product lines
      _sumProducts = _newTransactions.length;
      await Future.delayed(Durations.short1);

      // Notify listeners
      notifyListeners();
    } else {
      if (kDebugMode) {
        print(
          "Warning: Attempted to remove item by ID '$productIdToRemove', but it wasn't found.",
        );
      }
    }
  }

  String _submissionStatusMessage = ''; // Optional: For detailed feedback

  String get submissionStatusMessage => _submissionStatusMessage;
  set submissionStatusMessage(String val) {
    _submissionStatusMessage = val;
    notifyListeners();
  }

  Future<bool> buyProducts({
    // required BuildContext context,
    // required String stockEvent,
    required bool isAdmin,
  }) async {
    if (isBusy || _newTransactions.isEmpty) {
      submissionStatusMessage = "Silahkan buat pembelian.";
      return false;
    }

    isBusy = true;
    _submissionStatusMessage = '';
    notifyListeners(); // Notify started

    bool success = false;

    try {
      // Prepare the data payload for the batch endpoint
      // Convert each ProductTransaction to a Map matching backend expectation
      List<Map<String, dynamic>> transactionsPayload =
          _newTransactions.map((tx) {
            return {
              // Map fields from ProductTransaction to match backend expected fields
              'metricId':
                  tx.productDetail['metricId'], // Adjust based on your ProductTransaction structure
              'stockEvent': tx.stockEvent, // Or get from tx if variable
              'amount': tx.productAmount,
              'salesId': salesId, // Or get from tx / global state
              'subAgentId': subAgentId, // Or get from tx / global state
              'agentId': agentId, // Or get from tx / global state
              'shopId':
                  tx.shopId, // Assuming shopId is stored in ProductTransaction
              'status': 'created', // Or let backend decide
              'description':
                  null, //tx.description, // Assuming description is available
              // Add any other fields expected by _internalCreateSingleStock's itemData
            };
          }).toList();
      // Call the new batch API helper
      // await _performBatchPurchaseApiCall({'transactions': transactionsPayload});
      await ApiService().createStockBatch(
        batchData: {'transactions': transactionsPayload},
      );

      // If API call doesn't throw, assume success
      success = true;
      _submissionStatusMessage = "All purchases submitted successfully!";
      clearNewTransactions(isFromUI: true); // Clear list on success
    } catch (e) {
      // API call failed (network error, 4xx/5xx response)
      success = false;
      _submissionStatusMessage = "Purchase submission failed: ${e.toString()}";
      // Keep the _newTransactions list as is, because the backend likely rolled back
      if (kDebugMode) {
        print("Batch purchase failed: $e");
      }
    } finally {
      isBusy = false;
      notifyListeners(); // Notify finished + state changes
    }

    return success;

    // if (isBusy || _newTransactions.isEmpty) {
    //   // Prevent concurrent submissions or submitting an empty list
    //   return false;
    // }
    // _submissionStatusMessage = '';
    // isBusy = true;
    // // Work on a copy in case the original list is modified elsewhere unexpectedly,
    // // although UI should typically be blocked during submission.
    // List<ProductTransaction> transactionsToProcess = List.from(
    //   _newTransactions,
    // );
    // List<Map<String, dynamic>> failedPurchases =
    //     []; // To store info about failures

    // bool allSucceeded = true;

    // try {
    //   // Process transactions sequentially
    //   for (var transaction in transactionsToProcess) {
    //     try {
    //       // --- Call the actual API method for one item ---

    //       // await _performSinglePurchaseApiCall(transaction);
    //       // If it doesn't throw, assume success for this item

    //       // metricId stockEvent stockAmount status
    //       metricId = transaction.productDetail['metricId'];
    //       shopId = transaction.shopId;
    //       stockEvent = transaction.stockEvent;
    //       stockAmount = transaction.productAmount;
    //       status = 'created';

    //       await createStock(isAdmin: isAdmin);
    //       if (kDebugMode) {
    //         print("Successfully purchased: ${transaction.productId}");
    //       }
    //     } catch (e) {
    //       // --- Handle failure for this specific item ---
    //       allSucceeded = false;
    //       if (kDebugMode) {
    //         print("Failed purchase for ${transaction.productId}: $e");
    //       }
    //       failedPurchases.add({
    //         'productId': transaction.productId,
    //         // Consider adding product name if available
    //         'amount': transaction.productAmount,
    //         'error': e.toString(), // Store error message
    //       });

    //       // --- Decision: Stop on first error? ---
    //       // Option 1: Stop processing immediately on first failure
    //       // throw Exception("Purchase failed for ${transaction.productId}. Stopping.");

    //       // Option 2: Continue processing remaining items (implemented here)
    //       // Just record the failure and continue the loop
    //     }
    //   } // End of loop

    //   // --- Process Results After Loop ---
    //   if (allSucceeded) {
    //     clearNewTransactions(
    //       isFromUI: null,
    //     ); // This already calls notifyListeners()
    //     _submissionStatusMessage = "All purchases submitted successfully!";
    //     // Clear the list only if everything succeeded
    //   } else {
    //     _submissionStatusMessage =
    //         "Purchase submission completed with ${failedPurchases.length} failure(s).";
    //     // Decide if you want to remove successful items or leave the list as is
    //     // For simplicity here, we leave the list unchanged if there were failures,
    //     // allowing the user to potentially retry or remove failed items.
    //     // You could implement logic to remove only successful items if desired.
    //     int successCount =
    //         transactionsToProcess.length - failedPurchases.length;
    //     _submissionStatusMessage =
    //         "Partial success: $successCount items purchased, ${failedPurchases.length} failed.";

    //     // --- Logic to remove successful items ---
    //     // 1. Get the set of product IDs that failed
    //     Set<String> failedProductIds =
    //         failedPurchases.map((f) => f['productId'] as String).toSet();

    //     // 2. Modify the *original* list (_newTransactions) in place.
    //     // Keep only the elements whose productId is present in the failed set.
    //     _newTransactions.retainWhere(
    //       (tx) => failedProductIds.contains(tx.productId),
    //     );

    //     // 3. Recalculate the summary totals based on the remaining (failed) items
    //     _recalculateSummaries();
    //     // --- End modification ---
    //   }
    // } catch (e) {
    //   // Catch any unexpected error during the overall process (like the rethrow from Option 1 above)
    //   allSucceeded = false;
    //   _submissionStatusMessage =
    //       "An unexpected error occurred during purchase submission: $e";
    //   if (kDebugMode) {
    //     print(_submissionStatusMessage);
    //   }
    // } finally {
    //   // --- Ensure loading state is reset ---
    //   isBusy = false;
    //   notifyListeners(); // Notify UI about loading state and potential message change
    // }

    // // You might want to expose 'failedPurchases' list via a getter if UI needs details
    // return allSucceeded;
  }

  // Method to clear transactions and reset sums (potentially called by submitPurchases)
  void clearNewTransactions({bool? isFromUI}) {
    _newTransactions.clear();
    _sumTransactions = 0.0;
    _sumProducts = 0;
    _sumItems = 0;
    // Don't notifyListeners here if called from submitPurchases's finally block
    // Let the caller (submitPurchases) handle the final notification.
    // If called directly from UI, uncomment the line below:
    // notifyListeners();
    if (isFromUI == true) {
      notifyListeners();
    }
  }

  Future<bool> getStockBatches({
    required BuildContext context,
    required bool isClient,
    required String status,
    required String? sortBy,
    required String? sortOrder,
    required int? page,
    required int? limit,
  }) async {
    isBusy = true;
    responseBatch = [];

    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    dynamic response = await ApiService().getStockBatches(
      context: context,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      createdBy: isClient ? createdBy : null,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: page,
      limit: limit,
    );

    if (response == null) {
      isBusy = false;
      return false;
    } else {
      responseBatch = response['data'];
      isBusy = false;
      return true;
    }
  }

  Future<bool?> settleStockBatch({required String batchId}) async {
    isBusy = true;

    return await ApiService().settleStockBatch(batchId: batchId);
  }

  Future<bool?> cancelStockBatch({required String batchId}) async {
    isBusy = true;

    return await ApiService().cancelStockBatch(batchId: batchId);
  }

  // /// --- NEW: Helper to recalculate summaries from the current _newTransactions list ---
  // void _recalculateSummaries() {
  //   double newSumTransactions = 0.0;
  //   int newSumItems = 0;
  //   for (var tx in _newTransactions) {
  //     newSumTransactions += tx.totalPrice;
  //     newSumItems += tx.productAmount;
  //   }
  //   _sumTransactions = newSumTransactions;
  //   _sumItems = newSumItems;
  //   _sumProducts = _newTransactions.length;
  //   // Do NOT call notifyListeners here, the caller should handle it.
  // }

  Future<bool> fetchPercentages() async {
    percentages = await ApiService().getAllPercentages();
    notifyListeners();
    return true;
  }

  Future<bool?> createPercentages({
    required String key,
    required int value,
  }) async {
    isBusy = true;
    bool? response;
    bool? resp = await ApiService().createPercentage(key: key, value: value);

    if (resp == true) {
      percentages = await ApiService().getAllPercentages();
    }

    response = resp;

    return response;
  }

  Future<bool> updatePercentages({
    required BuildContext context,
    required String id,
    required int value,
  }) async {
    isBusy = true;
    bool response;
    bool resp = await ApiService().updatePercentage(
      context: context,
      id: id,
      value: value,
    );

    if (resp == true) {
      percentages = await ApiService().getAllPercentages();
    }

    response = resp;

    return response;
  }

  String generateDateString(DateTime time) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(time);
  }
}
