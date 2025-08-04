// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/components/client_content.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class DashboardMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile>
    with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    bool isClient =
        (get<SystemViewModel>().level ?? 0) < 4 ||
        (get<SystemViewModel>().level ?? 0) > 5;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
        actions: [
          if (watchOnly((SystemViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),

          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "WELCOME",
                  // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            ),
            Text(
              get<SystemViewModel>().name ?? "",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            SizedBox(height: 40),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDatePicker(
                        context,
                        "From: ",
                        watchOnly((StockViewModel x) => x.dateFromFilter),
                        // get<StockViewModel>().dateFromFilter,
                        (date) {
                          get<StockViewModel>().dateFromFilter = date;
                        },
                      ),

                      _buildDatePicker(
                        context,
                        "To: ",
                        watchOnly((StockViewModel x) => x.dateToFilter),
                        // get<StockViewModel>().dateToFilter,
                        (date) {
                          get<StockViewModel>().dateToFilter = date;
                        },
                      ),
                      SizedBox(
                        width: 50,
                        child: GradientElevatedButton(
                          padding: EdgeInsets.zero,
                          buttonHeight: 34,
                          onPressed: () async {
                            if (isClient) {
                              if (get<SystemViewModel>().salesId != null &&
                                  get<SystemViewModel>().salesId!.isNotEmpty) {
                                await get<StockViewModel>()
                                    .fetchClientCommissionData(
                                      context: context,
                                      id: get<SystemViewModel>().salesId!,
                                      clientType: "salesman",
                                    );
                              }
                              if (get<SystemViewModel>().subAgentId != null &&
                                  get<SystemViewModel>()
                                      .subAgentId!
                                      .isNotEmpty) {
                                await get<StockViewModel>()
                                    .fetchClientCommissionData(
                                      context: context,
                                      id: get<SystemViewModel>().subAgentId!,
                                      clientType: "subAgent",
                                    );
                              }
                              if (get<SystemViewModel>().agentId != null &&
                                  get<SystemViewModel>().agentId!.isNotEmpty) {
                                await get<StockViewModel>()
                                    .fetchClientCommissionData(
                                      context: context,
                                      id: get<SystemViewModel>().agentId!,
                                      clientType: "agent",
                                    );
                              }
                              if (get<SystemViewModel>().shopId != null &&
                                  get<SystemViewModel>().shopId!.isNotEmpty) {
                                await get<StockViewModel>()
                                    .fetchClientCommissionData(
                                      context: context,
                                      id: get<SystemViewModel>().shopId!,
                                      clientType: "shop",
                                    );
                              }
                            } else {
                              await get<StockViewModel>().fetchCommissionData(
                                context: context,
                              );
                            }
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (get<StockViewModel>().isBusy)
                    Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),

            if (isClient &&
                (watchOnly((StockViewModel x) => x.clientCommissionData) !=
                        null &&
                    get<StockViewModel>().clientCommissionData!.isNotEmpty))
              ClientContent(),

            isClient
                ? SizedBox()
                : _buildCommissionCard(
                  "Total Commission",
                  (get<StockViewModel>().commissionData?['totalCommission'] ??
                          0 as num)
                      .toDouble(),
                ),
            isClient
                ? SizedBox()
                : _buildCommissionCard(
                  "Distributor",
                  (get<StockViewModel>()
                              .commissionData?['distributorCommission'] ??
                          0 as num)
                      .toDouble(),
                ),
            isClient
                ? SizedBox()
                : _buildCommissionCard(
                  "Agent",
                  (get<StockViewModel>().commissionData?['agentCommission'] ??
                          0 as num)
                      .toDouble(),
                ),
            isClient
                ? SizedBox()
                : _buildCommissionCard(
                  "SubAgent",
                  (get<StockViewModel>()
                              .commissionData?['subAgentCommission'] ??
                          0 as num)
                      .toDouble(),
                ),
            isClient
                ? SizedBox()
                : _buildCommissionCard(
                  "Salesman",
                  (get<StockViewModel>()
                              .commissionData?['salesmanCommission'] ??
                          0 as num)
                      .toDouble(),
                ),
            isClient
                ? SizedBox()
                : _buildCommissionCard(
                  "Shop",
                  (get<StockViewModel>().commissionData?['shopCommission'] ??
                          0 as num)
                      .toDouble(),
                ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100002)),
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
