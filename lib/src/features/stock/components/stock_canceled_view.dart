import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_table_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockCanceledView extends StatelessWidget with GetItMixin {
  StockCanceledView({super.key});

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
                padding: EdgeInsets.zero,
                buttonHeight: 34,
                onPressed: () {
                  bool isClient =
                      (get<SystemViewModel>().level ?? 0) < 4 ||
                      (get<SystemViewModel>().level ?? 0) > 5;
                  String? userClient = get<StockViewModel>().client;

                  get<StockViewModel>().getStockTable(
                    context: context,
                    status: 'canceled',
                    isClient:
                        (get<SystemViewModel>().level ?? 0) < 4 ||
                        (get<SystemViewModel>().level ?? 0) > 5,
                    salesId:
                        isClient
                            ? userClient == "salesman"
                                ? get<SystemViewModel>().salesId
                                : null
                            : null,
                    subAgentId:
                        isClient
                            ? userClient == "subagent"
                                ? get<SystemViewModel>().subAgentId
                                : null
                            : null,
                    agentId:
                        isClient
                            ? userClient == "agent"
                                ? get<SystemViewModel>().agentId
                                : null
                            : null,
                    shopId:
                        isClient
                            ? userClient == "shop"
                                ? get<SystemViewModel>().shopId
                                : null
                            : null,
                    stockEvent: null,
                  );
                },
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        watchOnly((StockViewModel x) => x.stockOnCanceledTable).isEmpty
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
                  itemCount: get<StockViewModel>().stockOnCanceledTable.length,

                  itemBuilder: (context, index) {
                    return StockTableCard(
                      key: ValueKey(index + 12000),
                      isMobile: true,
                      stock: get<StockViewModel>().stockOnCanceledTable[index],
                      stockStatus: 'canceled',
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
