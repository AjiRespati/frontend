import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SettingsMobile extends StatelessWidget with GetItMixin {
  SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user = watchOnly((SystemViewModel x) => x.user);
    print(user);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Username: " + user?['username'] ?? " -"),
            Text("Level: ${user?['level'] ?? 0}"),

            GradientElevatedButton(
              onPressed: () async {
                bool isLogout = await get<SystemViewModel>().logout(
                  context: context,
                );
                if (isLogout) {
                  Navigator.pushReplacementNamed(context, signInRoute);
                }
              },
              child: Text("Logout"),
            ),
          ],
        ),
        // child:
        //     user != null
        //         ? Column(
        //           children: [
        //             Text(user?['username'] ?? " -"),

        //           ],
        //         )
        //         : SizedBox(child: Column(
        //           children: [
        //               GradientElevatedButton(
        //                 onPressed: () async {
        //                   bool isLogout = await get<SystemViewModel>().logout(
        //                     context: context,
        //                   );
        //                   if (isLogout) {
        //                     Navigator.pushReplacementNamed(
        //                       context,
        //                       signInRoute,
        //                     );
        //                   }
        //                 },
        //                 child: Text("Logout"),
        //               ),

        //           ],
        //         ),),
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
