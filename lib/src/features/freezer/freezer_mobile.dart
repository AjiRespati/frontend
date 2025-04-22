import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/freezer/components/add_freezer.dart';
import 'package:frontend/src/features/freezer/components/freezer_table_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class FreezerMobile extends StatelessWidget with GetItMixin {
  FreezerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.freezers);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          SizedBox(width: 5),
          Text("Add Freezer"),
          SizedBox(width: 5),
          AddButton(
            size: 32,
            message: "Tambah Toko",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: 540),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(child: AddFreezer()),
                  );
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height:
                  (MediaQuery.of(context).size.height - 150) -
                  (kIsWeb ? 5 : 50),
              child: ListView.builder(
                itemCount: get<StockViewModel>().freezers.length,
                itemBuilder: (context, index) {
                  return FreezerTableCard(
                    isMobile: true,
                    freezer: get<StockViewModel>().freezers[index],
                    key: ValueKey(index + 5000),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
