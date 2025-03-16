import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/stock_desktop.dart';
import 'package:frontend/src/features/stock/stock_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: StockMobile(),
      desktopLayout: StockDesktop(),
    );
  }
}
