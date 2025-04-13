// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdateLevelContent extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateLevelContent({
    required this.id,
    required this.username,
    required this.level,
    super.key,
  });

  final String id;
  final String username;
  final int level;

  @override
  State<UpdateLevelContent> createState() => _UpdateLevelContentState();
}

class _UpdateLevelContentState extends State<UpdateLevelContent>
    with GetItStateMixin {
  bool _isBusy = false;
  final formKey = GlobalKey<FormState>();
  int levelChoosenInt = 0;
  String levelChoosen = "Basic";

  @override
  void initState() {
    super.initState();
    levelChoosen = get<SystemViewModel>().levelList[widget.level];
    levelChoosenInt = widget.level;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              widget.username,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text("Update Level", style: TextStyle(fontSize: 12)),
            SizedBox(height: 40),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(isDense: true),
              value: levelChoosen,
              items:
                  get<SystemViewModel>().levelList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: (value) {
                levelChoosen = value ?? "Basic";
                levelChoosenInt = get<SystemViewModel>().levelList.indexOf(
                  value ?? "Basic",
                );
              },
            ),

            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  GradientElevatedButton(
                    // inactiveDelay: Duration.zero,
                    onPressed: () async {
                      setState(() => _isBusy = true);
                      await get<SystemViewModel>().updateUser(
                        context: context,
                        id: widget.id,
                        level: levelChoosenInt,
                        status: null,
                      );
                      await get<SystemViewModel>().getAllUser(context);
                      setState(() => _isBusy = false);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Update Level',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (_isBusy)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 5),
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
