// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/models/product_transaction.dart';
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
  List<dynamic> _stockOnCanceledTable = [];
  List<dynamic> _stockHistoryTable = [];
  dynamic _stockResume;
  List<dynamic> _salesStockTable = [];

  DateTime _dateFromFilter = DateTime.now().subtract(Duration(days: 7));
  DateTime _dateToFilter = DateTime.now();
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

  List<dynamic> _shops = [];
  List<dynamic> _freezers = [];
  List<dynamic> _idleFreezers = [];

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
    }
  }

  fetchProducts(BuildContext context) async {
    isLoading = true;
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
    isLoading = false;
  }

  Future<dynamic> fetchProduct(BuildContext context, String productId) async {
    isLoading = true;
    dynamic data = await apiService.fetchProduct(context, productId);
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

  //TODO: Jual Beli stock.
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
    stock = await apiService.fetchStockByProduct(context, productId);
    isBusy = false;
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

  fetchSubAgents({
    required BuildContext context,
    required bool isInitial,
  }) async {
    isLoading = true;
    subAgents = await apiService.getSubAgents(context);
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

  fetchAgents({required BuildContext context, required bool isInitial}) async {
    isLoading = true;
    agents = await apiService.getAgents(context);
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

  Future<bool> getStockTable({
    required BuildContext context,
    required String status,
  }) async {
    isBusy = true;
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    List<dynamic> response = await apiService.getStockTable(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      status: status,
    );

    switch (status) {
      case 'settled':
        stockTable = response;
        break;
      case 'created':
        stockOnProgressTable = response;
        break;
      default:
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
    required String salesId,
  }) async {
    isBusy = true;
    String fromDate = generateDateString(dateFromFilter);
    String toDate = generateDateString(dateToFilter.add(Duration(days: 1)));

    stockResume = await apiService.getStockResume(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
      salesId: salesId,
    );

    isBusy = false;
    return true;
  }

  Future<bool> getTableBySalesId({
    required BuildContext context,
    required String salesId,
  }) async {
    isBusy = true;
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

  Future<bool> createShop({
    required BuildContext context,
    required String salesId,
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
  }) async {
    isBusy = true;
    shops = await apiService.getAllShopsBySales(
      context: context,
      salesId: salesId,
    );
    print(shops.first);
    isBusy = false;
    return true;
  }

  Future<bool> getAllShops({required BuildContext context}) async {
    isBusy = true;
    shops = await apiService.getAllShops(context: context);
    print(shops.first);
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

  addProductTransaction(ProductTransaction val) {
    // Find the index of an existing transaction with the same productId
    // Returns -1 if no matching element is found.
    int existingIndex = _newTransactions.indexWhere(
      (el) => el.productId == val.productId,
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

  String generateDateString(DateTime time) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(time);
  }
}
