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
              child: GradientElevatedButton(
                inactiveDelay: Duration.zero,
                onPressed: () async {
                  await get<SystemViewModel>().updateUser(
                    id: widget.id,
                    level: levelChoosenInt,
                    status: null,
                  );
                  await get<SystemViewModel>().getAllUser();
                  Navigator.pop(context);
                },
                child: Text(
                  'Update Level',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
