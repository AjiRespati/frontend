// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
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
  List<String> levelList = [
    "Basic",
    "Sales",
    "Sub Agent",
    "Agent",
    "Admin",
    "Owner",
    "Shop",
  ];

  dynamic _user;
  List<dynamic> _users = [];

  String? _username;
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  int? _level;
  String? _salesId;
  String? _subAgentId;
  String? _agentId;
  String? _shopId;
  String? _shopParentId;
  String? _shopParentType;

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

  List<dynamic> get users => _users;
  set users(List<dynamic> val) {
    _users = val;
    notifyListeners();
  }

  String? get username => _username;
  set username(String? val) {
    _username = val;
    notifyListeners();
  }

  String? get name => _name;
  set name(String? val) {
    _name = val;
    notifyListeners();
  }

  String? get email => _email;
  set email(String? val) {
    _email = val;
    notifyListeners();
  }

  String? get phone => _phone;
  set phone(String? val) {
    _phone = val;
    notifyListeners();
  }

  String? get address => _address;
  set address(String? val) {
    _address = val;
    notifyListeners();
  }

  int? get level => _level;
  set level(int? val) {
    _level = val;
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

  String? get shopParentId => _shopParentId;
  set shopParentId(String? val) {
    _shopParentId = val;
    notifyListeners();
  }

  String? get shopParentType => _shopParentType;
  set shopParentType(String? val) {
    _shopParentType = val;
    notifyListeners();
  }

  //====================//
  //       METHOD       //
  //====================//

  bool isTokenExpired(String token) {
    // if (token == null) {
    //   return true;
    // }

    // bool isNeedRefresh = JwtDecoder.isExpired(token);
    // if (isNeedRefresh) {
    //   apiService.refreshAccessToken();
    // }
    return JwtDecoder.isExpired(token);
  }

  Future<bool> onLogin() async {
    isBusy = true;
    user = await apiService.login(
      usernameController.text,
      passwordController.text,
    );
    if (user != null) {
      // isBusy = false;

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? refreshToken = prefs.getString('refreshToken');
      // usernameController.text = "";
      // passwordController.text = "";

      // user = await apiService.self(context, refreshToken ?? "-");

      name = user?['name'];
      username = user?['username'];
      email = user?['email'];
      phone = user?['phone'];
      address = user?['address'];
      level = user?['level'];
      salesId = user?['salesId'];
      subAgentId = user?['subAgentId'];
      agentId = user?['agentId'];
      shopId = user?['shopId'];
      return true;
    } else {
      isBusy = false;
      return false;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }

  Future<bool> logout({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    bool isLogout = await apiService.logout(refreshToken ?? "");
    prefs.remove('refreshToken');
    prefs.remove('accessToken');
    salesId = null;
    subAgentId = null;
    agentId = null;
    shopId = null;
    level = null;
    currentPageIndex = 0;
    isLoginView = true;
    user = null;

    return isLogout;
  }

  Future<bool> self(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    user = await apiService.self(context, refreshToken ?? "-");

    if (user == null) {
      return false;
    } else {
      if (user?['level'] != 6) {
        name = user?['name'];
        username = user?['username'];
        email = user?['email'];
        phone = user?['phone'];
        address = user?['address'];
        level = user?['level'];
        salesId = user?['salesId'];
        subAgentId = user?['subAgentId'];
        agentId = user?['agentId'];
        shopId = user?['shopId'];
      } else {
        String parentType = "";
        if (user?['salesId'] != null) {
          parentType = 'sales';
        } else if (user?['subAgentId'] != null) {
          parentType = 'subAgent';
        } else {
          parentType = 'agent';
        }
        name = user?['name'];
        username = user?['username'];
        email = user?['email'];
        phone = user?['phone'];
        address = user?['address'];
        level = user?['level'];
        shopId = user?['shopId'];
        shopParentId =
            user?['salesId'] ?? user?['subAgentId'] ?? user?['agentId'];
        shopParentType = parentType;
      }
      return true;
    }
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

  Future<bool> getAllUser(BuildContext context) async {
    var response = await apiService.getAllUser(context);

    users = response;
    return true;
  }

  Future<bool> updateUser({
    required BuildContext context,
    required String id,
    required int? level,
    required String? status,
  }) async {
    return apiService.updateUser(
      context: context,
      id: id,
      level: level,
      status: status,
    );
  }

  Future<bool> genericTable({
    required BuildContext context,
    required String table,
  }) async {
    return apiService.generic(context, table);
  }

  Future<bool> changePassword({required String newPassword}) async {
    return apiService.changePassword(newPassword: newPassword);
  }
}
