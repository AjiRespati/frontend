import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationInfo {
  /// Prevents from object instantiation.
  ApplicationInfo._();

  static const appName = "Ice Stock 1.0";

  static const baseUrlDev =
      kIsWeb ? 'http://localhost:3000/api' : "http://10.0.2.2:3000/api";
  static const baseUrlProd = "http://10.0.2.2:3000/api";

  static const baseUrl = baseUrlDev;
  // static const baseUrl = baseUrlProd;

  static const isProduction = baseUrl == baseUrlProd;

  static const appVersion = '1.0.0 ${isProduction ? "" : "DEV"}';

  static const secondColor = Color.fromARGB(255, 171, 203, 60);
  static const thirdColor = Colors.amber;

  static const measurements = [
    "kg",
    "g",
    "liter",
    "bucket",
    "carton",
    "box",
    "pcs",
  ];
}
