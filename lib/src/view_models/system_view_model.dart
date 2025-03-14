import 'package:flutter/material.dart';

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
}
