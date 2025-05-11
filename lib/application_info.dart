import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationInfo {
  /// Prevents from object instantiation.
  ApplicationInfo._();

  static const baseUrlDev =
      kIsWeb
          ? 'http://localhost:3000/service/api'
          : "http://10.0.2.2:3000/service/api";

  static const baseUrlProd = "https://gracia.id/service/api";

  //TODO: Ganti manual untuk prod/dev
  // static const baseUrl = baseUrlDev;
  static const baseUrl = baseUrlProd;

  static const isProduction = baseUrl == baseUrlProd;

  static const appVersion = '1.1.0 ${isProduction ? "" : "DEV"}';

  static const appName = "Gracia Rafflesia";

  static const secondColor = Color.fromARGB(255, 171, 203, 60);
  static const thirdColor = Colors.amber;

  static const measurements = [
    // "kg",
    // "g",
    "carton",
    "liter",
    // "bucket",
    // "box",
    // "pcs",
  ];

  //TODO: DEVELOPER SWITCH
  static const isDevelOn = false;

  static const lowStockNumber = 5;
}
