import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/dashboard.dart';
import 'package:frontend/src/features/products/add_product.dart';
import 'package:frontend/src/features/suppliers/add_supplier.dart';
import 'package:frontend/src/features/suppliers/suppliers.dart';
import 'package:frontend/src/features/warehouses/add_warehouse.dart';
import 'package:frontend/src/features/warehouses/warehouses.dart';
import '../features/auth/login_screen.dart';
import '../features/products/products.dart';
import '../widgets/not_found_page.dart';

import 'animate_route_transitions.dart';
import 'route_names.dart';

class AppRouter {
  static RouteFactory routes() {
    return ((settings) {
      // dynamic arguments = settings.arguments;
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
          screen = const Products();
          break;
        case suppliersRoute:
          screen = const Suppliers();
          break;
        case warehousesRoute:
          screen = const Warehouses();
          break;
        case addProductsRoute:
          screen = const AddProductScreen();
          break;
        case addSuppliersRoute:
          screen = const AddSupplierScreen();
          break;
        case addWarehousesRoute:
          screen = const AddWarehouseScreen();
          break;
        default:
          screen = const NotFoundPage();
      }

      return FadeRoute(page: screen, settings: settings);
    });
  }
}
