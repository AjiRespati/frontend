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
  dynamic _stock;

  String? _metricId;
  String _stockEvent = 'stock_in';
  String? _createdBy;
  int _stockAmount = 0;
  String? _salesId;
  String? _subAgentId;
  String? _agentId;
  String _status = 'created';
  String? _description;

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
    dynamic data = await apiService.fetchStockByProduct(productId);
    stock = data;
    isLoading = false;
    return;
  }
}
