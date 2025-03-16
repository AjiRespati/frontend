// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isBusy = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  int _currentPageIndex = 0;
  List<String> pageLabels = ["Home", "Stock", "Products", "Sales", "Setting"];

  //====================//
  //  GETTER n SETTER   //
  //====================//

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  bool get showPassword => _showPassword;
  set showPassword(bool val) {
    _showPassword = val;
    notifyListeners();
  }

  int get currentPageIndex => _currentPageIndex;
  set currentPageIndex(int val) {
    _currentPageIndex = val;
    notifyListeners();
  }

  //====================//
  //       METHOD       //
  //====================//

  /// call this method after mounted
  checkSession({required BuildContext context}) async {
    isBusy = true;
    SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('accessToken');

    if (!isTokenExpired(token)) {
      Navigator.pushNamed(context, dashboardRoute);
      isBusy = false;
    } else {
      isBusy = false;
    }
  }

  bool isTokenExpired(String? token) {
    if (token == null) {
      return true;
    }

    bool isNeedRefresh = JwtDecoder.isExpired(token);
    if (isNeedRefresh) {
      apiService.refreshAccessToken();
    }
    return JwtDecoder.isExpired(token);
  }

  void onLogin({required BuildContext context}) async {
    bool isLogin = await apiService.login(
      usernameController.text,
      passwordController.text,
    );
    if (isLogin) {
      usernameController.text = "";
      passwordController.text = "";
      Navigator.pushReplacementNamed(context, dashboardRoute);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }
}
