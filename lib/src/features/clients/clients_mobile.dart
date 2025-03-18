import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/components/add_client.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientsMobile extends StatelessWidget with GetItMixin {
  ClientsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_bike), text: "Salesman"),
              Tab(icon: Icon(Icons.directions_car), text: "Sub Agent"),
              Tab(icon: Icon(Icons.directions_transit), text: 'Agent'),
            ],
          ),
          title: const Text('Clients'),
          actions: [
            AddButton(
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
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
        bottomNavigationBar: MobileNavbar(),
      ),
    );
  }
}
