import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class DashboardMobile extends StatelessWidget with GetItMixin {
  DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HEADER")),
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          get<SystemViewModel>().currentPageIndex = value;
          switch (value) {
            case 0:
              Navigator.pushNamed(context, dashboardRoute);
              break;
            case 1:
              Navigator.pushNamed(context, homeRoute); // stock
              break;
            case 2:
              Navigator.pushNamed(context, productsRoute);
              break;
            case 3:
              Navigator.pushNamed(context, suppliersRoute);
              break;
            default:
          }
        },
        selectedIndex: get<SystemViewModel>().currentPageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_checkout_rounded),
            label: "Stock",
          ),
          NavigationDestination(
            icon: Icon(Icons.factory_rounded),
            label: "Products",
          ),
          NavigationDestination(
            icon: Icon(Icons.store_rounded),
            label: "Sales",
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
        ],
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
