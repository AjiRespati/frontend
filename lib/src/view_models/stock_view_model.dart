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

  Map<String, dynamic>? _commissionData;
  List<dynamic> _products = [];

  //====================//
  //  GETTER n SETTER   //
  //====================//

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

  //====================//
  //       METHOD       //
  //====================//

  fetchCommissionData({required BuildContext context}) async {
    final data = await apiService.fetchCommissionSummary(context: context);
    if (data['message'] == "Invalid token") {
      Navigator.pushReplacementNamed(context, signInRoute);
    } else {
      commissionData = data;
    }
  }

  fetchProducts() async {
    List<dynamic> data = await apiService.fetchProducts();
    products = data;
    isLoading = false;
  }
}
