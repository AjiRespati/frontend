import 'package:flutter/material.dart';
import 'package:frontend/src/features/auth/login_content.dart';
import 'package:frontend/src/features/auth/register_content.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginMobile extends StatelessWidget with GetItMixin {
  LoginMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Welcome"),
        automaticallyImplyLeading: false,
        actions: [
          if (watchOnly((SystemViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),

          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            watchOnly((SystemViewModel x) => x.isLoginView)
                ? LoginContent()
                : RegisterContent(),
      ),
    );
  }
}
