import 'package:flutter/material.dart';
import 'package:frontend/src/features/freezer_management/components/add_freezer.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class FreezerMobile extends StatelessWidget with GetItMixin {
  FreezerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Freezer"),
        actions: [
          if (watchOnly((StockViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          AddButton(
            size: 32,
            message: "Tambah Toko",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: 540),
                context: context,
                builder: (context) {
                  return AddFreezer();
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
