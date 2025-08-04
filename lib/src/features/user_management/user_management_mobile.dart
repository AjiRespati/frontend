import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_management/components/user_table_card.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserManagementMobile extends StatelessWidget with GetItMixin {
  UserManagementMobile({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((SystemViewModel x) => x.users);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("User Management"),
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
        ],
      ),
      body:
          watchOnly((SystemViewModel x) => x.isBusy)
              ? SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.red),
              )
              : watchOnly((SystemViewModel x) => x.users).isEmpty
              ? Text("user not found")
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: get<SystemViewModel>().users.length,
                  itemBuilder: (context, index) {
                    var item = get<SystemViewModel>().users[index];
                    // print(item);
                    return UserTableCard(
                      key: ValueKey(index + 19000),
                      user: item,
                    );
                  },
                ),
              ),
      bottomNavigationBar: MobileNavbar(key: ValueKey(100009)),
    );
  }
}
