import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/components/client_content_detail.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientContent extends StatefulWidget with GetItStatefulWidgetMixin {
  ClientContent({super.key});

  @override
  State<ClientContent> createState() => _ClientContentState();
}

class _ClientContentState extends State<ClientContent> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (get<SystemViewModel>().salesId != null)
          _buildCommissionCard(
            "Komisi",
            (get<StockViewModel>().totalClientCommission),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: get<StockViewModel>().clientCommissionData?.length,
          itemBuilder: (context, index) {
            var item = get<StockViewModel>().clientCommissionData?[index];
            return Card(
              elevation: 0.5,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SingleChildScrollView(
                          child: ClientContentDetail(item: item),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatDateStringHM(item['createdAt'])),
                            Text(
                              item['Stocks'][0]['shopName'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(formatCurrency(item['totalSalesShareSum'])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommissionCard(String title, double value) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          formatCurrency(value),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
