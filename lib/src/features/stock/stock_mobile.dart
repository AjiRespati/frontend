import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_table_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
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
          // AddButton(
          //   message: "Add Product",
          //   onPressed: () {
          //     // showModalBottomSheet(
          //     //   isScrollControlled: true,
          //     //   constraints: BoxConstraints(maxHeight: 540),
          //     //   context: context,
          //     //   builder: (context) {
          //     //     return AddStock();
          //     //   },
          //     // );
          //   },
          // ),
          SizedBox(width: 20),
        ],
      ),
      body:
          watchOnly((StockViewModel x) => x.stockTable).isEmpty
              ? Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height:
                          (MediaQuery.of(context).size.height - 152) -
                          (kIsWeb ? 0 : 50),
                      child: ListView.builder(
                        itemCount: get<StockViewModel>().stockTable.length,

                        itemBuilder: (context, index) {
                          return StockTableCard(
                            isMobile: true,
                            stock: get<StockViewModel>().stockTable[index],
                          );
                        },
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SizedBox(
                  //     height:
                  //         (MediaQuery.of(context).size.height - 152) -
                  //         (kIsWeb ? 0 : 50),
                  //     child: GridView.builder(
                  //       gridDelegate:
                  //           const SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 1, // ✅ 2 Columns
                  //             crossAxisSpacing: 8,
                  //             mainAxisSpacing: 8,
                  //             childAspectRatio: 3, // ✅ Adjust aspect ratio
                  //           ),
                  //       itemCount: get<StockViewModel>().stockTable.length,
                  //       itemBuilder: (context, index) {
                  //         return StockTableCard(
                  //           isMobile: true,
                  //           stock: get<StockViewModel>().stockTable[index],
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
