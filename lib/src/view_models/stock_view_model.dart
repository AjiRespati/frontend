// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
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

  dynamic _stock;

  String? _metricId;
  String _stockEvent = 'stock_in';
  String _measurement = 'kg';
  String _client = 'salesman';
  final List<String> _clients = ['salesman', 'subAgent', "agent"];
  String? _createdBy;
  int _stockAmount = 0;
  String? _salesId;
  String? _subAgentId;
  String? _agentId;
  String _status = 'created';
  String? _description;
  int _clientTabIndex = 0;

  //====================//
  //  GETTER n SETTER   //
  //====================//

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

  dynamic get stock => _stock;
  set stock(dynamic val) {
    _stock = val;
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

  fetchProducts() async {
    isLoading = true;
    List<dynamic> data = await apiService.fetchProducts();
    products = data;
    isLoading = false;
  }

  Future<dynamic> fetchProduct(String productId) async {
    isLoading = true;
    dynamic data = await apiService.fetchProduct(productId);
    productsDetail = data;
    isLoading = false;
    return;
  }

  Future<void> createStock({required BuildContext context}) async {
    isLoading = true;

    final resp = await apiService.createStock(
      metricId,
      stockEvent,
      createdBy,
      stockAmount,
      salesId,
      subAgentId,
      agentId,
      status,
      description,
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
    if (!isInitial) {
      print('mosok kesini??');
      clientTabIndex = 2;
    } else {
      clientTabIndex = 0;
    }
    isLoading = false;
    return;
  }
}
