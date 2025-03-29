import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class DashboardMobile extends StatelessWidget with GetItMixin {
  DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dasboard"), automaticallyImplyLeading: false),
      body:
          watchOnly((StockViewModel x) => x.commissionData) == null
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
                    "Distributor",
                    (get<StockViewModel>()
                                .commissionData!['distributorCommission']
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
                    (get<StockViewModel>().commissionData!['subAgentCommission']
                            as num)
                        .toDouble(),
                  ),
                  _buildCommissionCard(
                    "Salesman",
                    (get<StockViewModel>().commissionData!['salesmanCommission']
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
