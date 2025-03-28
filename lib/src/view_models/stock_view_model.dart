// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class StockViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isBusy = false;
  bool _isLoading = true;
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _commissionData;
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
  List<dynamic> _stockHistoryTable = [];
  DateTime _dateFromFilter = DateTime.now().subtract(Duration(days: 7));
  DateTime _dateToFilter = DateTime.now();
  String? _choosenMetricId;

  String? _metricId;
  String _stockEvent = 'stock_in';
  String _measurement = "";
  List<String> measurements = ApplicationInfo.measurements;
  List<String> _availableMeasurement = [];
  int _price = 0;

  String _client = 'salesman';
  final List<String> _clients = ['salesman', 'subAgent', "agent"];
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

  String get client => _client;
  set client(String val) {
    _client = val;
    notifyListeners();
  }

  List<String> get clients => _clients;

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

  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Map<String, dynamic>? get commissionData => _commissionData;
  set commissionData(Map<String, dynamic>? val) {
    _commissionData = val;
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

  //====================//
  //       METHOD       //
  //====================//

  fetchCommissionData({required BuildContext context}) async {
    isLoading = true;
    final data = await apiService.fetchCommissionSummary(context: context);
    if (data['message'] == "Invalid token") {
      isLoading = false;
      Navigator.pushReplacementNamed(context, signInRoute);
    } else {
      isLoading = false;
      commissionData = data;
      print(data);
    }
  }

  fetchProducts() async {
    isLoading = true;
    List<dynamic> datas = await apiService.fetchProducts();
    Set<String> productIds = {};
    List<dynamic> data = [];

    for (var el in datas) {
      if (productIds.add(el['productId'])) {
        data.add(el);
      }
    }
    products = data;

    isLoading = false;
  }

  Future<dynamic> fetchProduct(String productId) async {
    isLoading = true;
    dynamic data = await apiService.fetchProduct(productId);
    productsDetail = data;
    List<String> usedMetric = [];
    if (productsDetail != null) {
      for (var i = 0; i < productsDetail!.length; i++) {
        var item = productsDetail![i];
        usedMetric.add(item['metricType']);
      }

      List<String> measurementLeft =
          measurements
              .where((measurement) => !usedMetric.contains(measurement))
              .toList();
      measurement = measurementLeft.first;
      availableMeasurement = measurementLeft;
    }

    isLoading = false;
    return;
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

  Future<void> createStock({
    required BuildContext context,
    // required String? salesName,
    // required String? subAgentName,
    // required String? agentName,
    // required String? shopName,
  }) async {
    isLoading = true;
    if (stockEvent == 'stock_out') {
      _generateClientId();
    } else {
      salesId = null;
      subAgentId = null;
      agentId = null;
    }

    final resp = await apiService.createStock(
      context: context,
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
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.green,
          content: Text(
            '${stockEvent == 'stock_out' ? "Send " : "Add "}stock, created successfully',
          ),
        ),
      );
    } else {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Text('Failed to create stock'),
        ),
      );
    }
  }

  Future<void> createMetric({
    required BuildContext context,
    required String productId,
    required String metricType,
    required double price,
  }) async {
    isLoading = true;

    final resp = await apiService.createMetric(
      context,
      productId,
      metricType,
      price,
    );

    if (resp) {
      isLoading = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Stock created successfully')));
    } else {
      isLoading = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create stock')));
    }
  }

  Future<dynamic> fetchStockByProduct(String productId) async {
    isLoading = true;
    stock = await apiService.fetchStockByProduct(productId);
    isLoading = false;
    return;
  }

  fetchSalesmen({required bool isInitial}) async {
    isLoading = true;
    salesmen = await apiService.getSalesmen();
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
    isLoading = false;
    return;
  }

  fetchSubAgents({required bool isInitial}) async {
    isLoading = true;
    subAgents = await apiService.getSubAgents();
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
    isLoading = false;
    return;
  }

  fetchAgents({required bool isInitial}) async {
    isLoading = true;
    agents = await apiService.getAgents();
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
    isLoading = false;
    return;
  }

  Future<bool> getStockTable({required String status}) async {
    isBusy = true;
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    List<dynamic> response = await apiService.getStockTable(
      fromDate: fromDate,
      toDate: toDate,
      status: status,
    );
    if (status == 'settled') {
      stockTable = response;
    } else {
      stockOnProgressTable = response;
    }
    isBusy = false;
    return true;
  }

  Future<bool> settlingStock({
    required String stockId,
    required String metricId,
  }) async {
    return await apiService.settlingStock(stockId: stockId, metricId: metricId);
  }

  Future<bool> getStockHistory({required String status}) async {
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    stockHistoryTable = await apiService.getStockHistoryTable(
      fromDate: fromDate,
      toDate: toDate,
      metricId: choosenMetricId ?? "",
      status: status,
    );

    print(stockHistoryTable);
    return true;
  }

  String generateDateString(DateTime time) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(time);
  }
}
