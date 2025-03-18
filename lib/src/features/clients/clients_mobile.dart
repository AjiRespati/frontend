import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/components/add_client.dart';
import 'package:frontend/src/features/clients/components/agent_view.dart';
import 'package:frontend/src/features/clients/components/salesmen_view.dart';
import 'package:frontend/src/features/clients/components/sub_agent_view.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientsMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  ClientsMobile({super.key});

  @override
  State<ClientsMobile> createState() => _ClientsMobileState();
}

class _ClientsMobileState extends State<ClientsMobile>
    with SingleTickerProviderStateMixin, GetItStateMixin {
  late TabController _tabController;
  int defaultTabIndex = 0; // Default tab index

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: defaultTabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = watchOnly((StockViewModel x) => x.clientTabIndex);
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.directions_bike), text: "Salesman"),
            Tab(icon: Icon(Icons.directions_car), text: "Sub Agent"),
            Tab(icon: Icon(Icons.directions_transit), text: 'Agent'),
          ],
        ),
        title: const Text('Clients'),
        actions: [
          AddButton(
            size: 32,
            message: "Add Product",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: 540),
                context: context,
                builder: (context) {
                  return AddClient();
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [SalesmenView(), SubAgentView(), AgentView()],
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
