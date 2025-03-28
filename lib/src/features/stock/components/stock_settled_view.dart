import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_table_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockSettledView extends StatelessWidget with GetItMixin {
  StockSettledView({super.key});

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
                inactiveDelay: Duration.zero,
                buttonHeight: 34,
                onPressed: () {
                  get<StockViewModel>().getStockTable(status: 'settled');
                },
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        watchOnly((StockViewModel x) => x.stockTable).isEmpty
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: Text("Tidak ada stok pada tanggal dipilih."),
                ),
              ],
            )
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height:
                    (MediaQuery.of(context).size.height - 280) -
                    (kIsWeb ? 0 : 50),
                child: ListView.builder(
                  itemCount: get<StockViewModel>().stockTable.length,

                  itemBuilder: (context, index) {
                    return StockTableCard(
                      isMobile: true,
                      stock: get<StockViewModel>().stockTable[index],
                      stockStatus: 'settled',
                    );
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
