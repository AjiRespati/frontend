import 'package:flutter/material.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockMobile extends StatelessWidget with GetItMixin {
  StockMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock")),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
