import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isBusy = false;

  Map<String, dynamic>? _commissionData;

  //====================//
  //  GETTER n SETTER   //
  //====================//

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  Map<String, dynamic>? get commissionData => _commissionData;
  set commissionData(Map<String, dynamic>? val) {
    _commissionData = val;
    notifyListeners();
  }

  //====================//
  //       METHOD       //
  //====================//

  void fetchCommissionData({required BuildContext context}) async {
    final data = await apiService.fetchCommissionSummary(context: context);
    if (data['message'] == "Invalid token") {
      Navigator.pushReplacementNamed(context, signInRoute);
    } else {
      commissionData = data;
    }
  }
}
