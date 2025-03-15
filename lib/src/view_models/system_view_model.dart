// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemViewModel extends ChangeNotifier {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isBusy = false;

  //====================//
  //  GETTER n SETTER   //
  //====================//

  bool get isBusy => _isBusy;
  set isBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  //====================//
  //       METHOD       //
  //====================//

  /// call this method after mounted
  checkSession({required BuildContext context}) async {
    isBusy = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      ApiService().refreshAccessToken();
    }
    return JwtDecoder.isExpired(token);
  }
}
