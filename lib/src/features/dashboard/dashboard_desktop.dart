import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/page_container.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class DashboardDesktop extends StatelessWidget with GetItMixin {
  DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,

        mainSection:
            get<StockViewModel>().commissionData == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    _buildCommissionCard(
                      "Total Commission",
                      (get<StockViewModel>().commissionData!['totalCommission']
                              as num)
                          .toDouble(),
                    ),
                    _buildCommissionCard(
                      "Agent",
                      (get<StockViewModel>().commissionData!['agentCommission']
                              as num)
                          .toDouble(),
                    ),
                    _buildCommissionCard(
                      "SubAgent",
                      (get<StockViewModel>()
                                  .commissionData!['subAgentCommission']
                              as num)
                          .toDouble(),
                    ),
                    _buildCommissionCard(
                      "Salesman",
                      (get<StockViewModel>()
                                  .commissionData!['salesmanCommission']
                              as num)
                          .toDouble(),
                    ),
                    _buildCommissionCard(
                      "Shop",
                      (get<StockViewModel>().commissionData!['shopCommission']
                              as num)
                          .toDouble(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/agentDetail');
                      },
                      child: const Text('View Agent Details'),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildCommissionCard(String title, double value) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          "\$${value.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
