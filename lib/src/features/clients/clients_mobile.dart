import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/components/agent_view.dart';
import 'package:frontend/src/features/clients/components/salesmen_view.dart';
import 'package:frontend/src/features/clients/components/sub_agent_view.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      // kalau index tidak berubah berarti swipe.
      if (!_tabController.indexIsChanging) {
        get<StockViewModel>().clientTabIndex = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          if (watchOnly((StockViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
          // AddButton(
          //   size: 32,
          //   message: "Add Product",
          //   onPressed: () {
          //     showModalBottomSheet(
          //       isScrollControlled: true,
          //       constraints: BoxConstraints(maxHeight: 540),
          //       context: context,
          //       builder: (context) {
          //         return AddClient();
          //       },
          //     ).then((value) {
          //       // mendengarkan tab setelah selesai request add
          //       _tabController.index = watchOnly(
          //         (StockViewModel x) => x.clientTabIndex,
          //       );
          //     });
          //   },
          // ),
          SizedBox(width: 20),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [SalesmenView(), SubAgentView(), AgentView()],
      ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100001)),
    );
  }
}
