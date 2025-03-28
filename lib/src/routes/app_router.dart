import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/clients.dart';
import 'package:frontend/src/features/dashboard/dashboard.dart';
import 'package:frontend/src/features/products/components/add_product.dart';
import 'package:frontend/src/features/products/product_detail.dart';
import 'package:frontend/src/features/settings/settings.dart';
import 'package:frontend/src/features/stock/stock.dart';
import 'package:frontend/src/features/stock/stock_detail/stock_detail.dart';
import '../features/auth/login_screen.dart';
import '../features/products/products.dart';
import '../widgets/not_found_page.dart';

import 'animate_route_transitions.dart';
import 'route_names.dart';

class AppRouter {
  static RouteFactory routes() {
    return ((settings) {
      dynamic arguments = settings.arguments;
      Widget screen;

      switch (settings.name) {
        case '/':
          screen = LoginScreen();
          break;
        case signInRoute:
          screen = LoginScreen();
          break;
        case dashboardRoute:
          screen = Dashboard();
          break;
        case productsRoute:
          screen = Products();
          break;
        case productDetailRoute:
          screen = ProductDetail(productId: arguments);
          break;
        case addProductsRoute:
          screen = AddProductScreen();
          break;
        case stockRoute:
          screen = Stock();
          break;
        case stockDetailRoute:
          screen = StockDetail();
          break;
        case clientsRoute:
          screen = Clients();
          break;
        case settingsRoute:
          screen = Settings();
          break;
        default:
          screen = const NotFoundPage();
      }

      return FadeRoute(page: screen, settings: settings);
    });
  }
}
