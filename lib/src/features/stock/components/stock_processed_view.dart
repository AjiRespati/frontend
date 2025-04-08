import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_client_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockProcessedView extends StatelessWidget with GetItMixin {
  StockProcessedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDatePicker(
                context,
                "From: ",
                get<StockViewModel>().dateFromFilter,
                (date) {
                  get<StockViewModel>().dateFromFilter = date;
                },
              ),

              _buildDatePicker(
                context,
                "To: ",
                get<StockViewModel>().dateToFilter,
                (date) {
                  get<StockViewModel>().dateToFilter = date;
                },
              ),
              GradientElevatedButton(
                // inactiveDelay: Duration.zero,
                buttonHeight: 34,
                onPressed: () {
                  get<StockViewModel>().getStockTable(
                    context: context,
                    status: 'created',
                    isClient: (get<SystemViewModel>().level ?? 0) < 4,
                  );
                },
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total Belum Dibayar:  "),
              Text(
                formatCurrency(get<StockViewModel>().totalOnProgress),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700,
                ),
              ),
              SizedBox(width: 13),
            ],
          ),
        ),
        watchOnly((StockViewModel x) => x.stockOnProgressTable).isEmpty
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: Text(
                    "Tidak ada stock yang perlu diproses didalam filter tanggal.",
                  ),
                ),
              ],
            )
            : Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: get<StockViewModel>().stockOnProgressTable.length,
                  itemBuilder: (context, index) {
                    // int level = get<SystemViewModel>().level ?? 0;
                    Map<String, dynamic> stock =
                        get<StockViewModel>().stockOnProgressTable[index];
                    return StockClientCard(
                      stockStatus: 'created',
                      isMobile: true,
                      stock: stock,
                    );
                    // if (level > 3) {
                    //   return StockTableCard(
                    //     stockStatus: 'created',
                    //     isMobile: true,
                    //     stock: stock,
                    //   );
                    // } else {
                    //   return StockClientCard(
                    //     stockStatus: 'created',
                    //     isMobile: true,
                    //     stock: stock,
                    //   );
                    // }
                  },
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: () async {
          DateTime? pickedDate = await showCustomDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
          );
          // );
          if (pickedDate != null) onDateSelected(pickedDate);
        },
        child: Text(
          label + (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
        ),
      ),
    );
  }
}
