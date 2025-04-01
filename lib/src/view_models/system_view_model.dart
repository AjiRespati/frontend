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
  bool _isLoginView = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  bool _showPassword = false;
  int _currentPageIndex = 0;
  List<String> pageLabels = ["Home", "Products", "Stock", "Sales"];
  // List<String> pageLabels = ["Home", "Stock", "Products", "Sales", "Setting"];

  dynamic _user;

  //====================//
  //  GETTER n SETTER   //
  //====================//

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  bool get isLoginView => _isLoginView;
  set isLoginView(bool val) {
    _isLoginView = val;
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

  dynamic get user => _user;
  set user(dynamic val) {
    _user = val;
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
      Navigator.pushReplacementNamed(context, dashboardRoute);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');
      usernameController.text = "";
      passwordController.text = "";

      user = await apiService.self(refreshToken ?? "-");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }

  Future<bool> logout({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    bool isLogout = await apiService.logout(refreshToken ?? "");
    prefs.remove('refreshToken');
    prefs.remove('accessToken');

    return isLogout;
  }

  void self() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    user = await apiService.self(refreshToken ?? "-");
  }

  Future<bool> register() async {
    return await apiService.register(
      username: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
    );
  }
}
