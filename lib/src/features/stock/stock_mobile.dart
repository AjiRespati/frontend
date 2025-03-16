import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/add_stock.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockMobile extends StatelessWidget with GetItMixin {
  StockMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock"),
        actions: [
          AddButton(
            message: "Add Product",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: 540),
                context: context,
                builder: (context) {
                  return AddStock();
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
