import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? commissionData;

  @override
  void initState() {
    super.initState();
    _fetchCommissionData();
  }

  void _fetchCommissionData() async {
    final data = await _apiService.fetchCommissionSummary();
    setState(() {
      commissionData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commission Dashboard')),
      body:
          commissionData == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildCommissionCard(
                    "Total Commission",
                    (commissionData!['totalCommission'] as num).toDouble(),
                  ),
                  _buildCommissionCard(
                    "Agent",
                    (commissionData!['agentCommission'] as num).toDouble(),
                  ),
                  _buildCommissionCard(
                    "SubAgent",
                    (commissionData!['subAgentCommission'] as num).toDouble(),
                  ),
                  _buildCommissionCard(
                    "Salesman",
                    (commissionData!['salesmanCommission'] as num).toDouble(),
                  ),
                  _buildCommissionCard(
                    "Shop",
                    (commissionData!['shopCommission'] as num).toDouble(),
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
