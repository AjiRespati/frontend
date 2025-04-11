import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class DashboardMobile extends StatelessWidget with GetItMixin {
  DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isClient = (get<SystemViewModel>().level ?? 0) < 4;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body:
          watchOnly((StockViewModel x) => x.isBusy)
              ? Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "WELCOME",
                      // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    Text(
                      get<SystemViewModel>().name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 40),

                    if (get<SystemViewModel>().salesId != null)
                      _buildCommissionCard(
                        "Commission",
                        (get<StockViewModel>()
                                    .commissionData?['salesmanCommission'] ??
                                0 as num)
                            .toDouble(),
                      ),

                    if (get<SystemViewModel>().subAgentId != null)
                      _buildCommissionCard(
                        "SubAgent",
                        (get<StockViewModel>()
                                    .commissionData?['subAgentCommission'] ??
                                0 as num)
                            .toDouble(),
                      ),

                    if (get<SystemViewModel>().agentId != null)
                      _buildCommissionCard(
                        "Agent",
                        (get<StockViewModel>()
                                    .commissionData?['agentCommission'] ??
                                0 as num)
                            .toDouble(),
                      ),

                    isClient
                        ? SizedBox()
                        : _buildCommissionCard(
                          "Total Commission",
                          (get<StockViewModel>()
                                      .commissionData?['totalCommission'] ??
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
                          (get<StockViewModel>()
                                      .commissionData?['agentCommission'] ??
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
                          (get<StockViewModel>()
                                      .commissionData?['shopCommission'] ??
                                  0 as num)
                              .toDouble(),
                        ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      // watchOnly((StockViewModel x) => x.commissionData) == null
      //     ? const Center(child: CircularProgressIndicator())
      //     : Column(
      //       children: [
      //         _buildCommissionCard(
      //           "Total Commission",
      //           (get<StockViewModel>().commissionData?['totalCommission']??0
      //                   as num)
      //               .toDouble(),
      //         ),
      //         _buildCommissionCard(
      //           "Distributor",
      //           (get<StockViewModel>()
      //                       .commissionData?['distributorCommission']??0
      //                   as num)
      //               .toDouble(),
      //         ),
      //         _buildCommissionCard(
      //           "Agent",
      //           (get<StockViewModel>().commissionData?['agentCommission']??0
      //                   as num)
      //               .toDouble(),
      //         ),
      //         _buildCommissionCard(
      //           "SubAgent",
      //           (get<StockViewModel>().commissionData?['subAgentCommission']??0
      //                   as num)
      //               .toDouble(),
      //         ),
      //         _buildCommissionCard(
      //           "Salesman",
      //           (get<StockViewModel>().commissionData?['salesmanCommission']??0
      //                   as num)
      //               .toDouble(),
      //         ),
      //         _buildCommissionCard(
      //           "Shop",
      //           (get<StockViewModel>().commissionData?['shopCommission']??0
      //                   as num)
      //               .toDouble(),
      //         ),
      //         const SizedBox(height: 20),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     Navigator.pushNamed(context, '/agentDetail');
      //         //   },
      //         //   child: const Text('View Agent Details'),
      //         // ),
      //       ],
      //     ),
      bottomNavigationBar: MobileNavbar(),
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
