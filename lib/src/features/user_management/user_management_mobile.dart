import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_management/components/user_table_card.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserManagementMobile extends StatelessWidget with GetItMixin {
  UserManagementMobile({super.key});

  @override
  Widget build(BuildContext context) {
    watchOnly((SystemViewModel x) => x.users);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
        actions: [
          if (watchOnly((SystemViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
        ],
      ),
      body:
          watchOnly((SystemViewModel x) => x.isBusy)
              ? SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              )
              : watchOnly((SystemViewModel x) => x.users).isEmpty
              ? Text("user not found")
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height:
                      (MediaQuery.of(context).size.height - 280) -
                      (kIsWeb ? 0 : 50),
                  child: ListView.builder(
                    itemCount: get<SystemViewModel>().users.length,

                    itemBuilder: (context, index) {
                      var item = get<SystemViewModel>().users[index];
                      return UserTableCard(user: item);
                    },
                  ),
                ),
              ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
