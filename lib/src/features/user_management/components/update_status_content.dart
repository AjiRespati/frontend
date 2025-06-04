// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdateStatusContent extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateStatusContent({
    required this.id,
    required this.oldStatus,
    required this.username,
    super.key,
  });

  final String id;
  final String oldStatus;
  final String username;

  @override
  State<UpdateStatusContent> createState() => _UpdateLevelContentState();
}

class _UpdateLevelContentState extends State<UpdateStatusContent>
    with GetItStateMixin {
  final formKey = GlobalKey<FormState>();
  bool _isBusy = false;
  String oldStatus = "Basic";

  @override
  void initState() {
    super.initState();
    oldStatus = widget.oldStatus;
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
            Text("Update Status", style: TextStyle(fontSize: 12)),
            SizedBox(height: 40),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(isDense: true),
              value: oldStatus,
              items:
                  ["new", "active", "inactive"].map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: (value) {
                oldStatus = value ?? "new";
                setState(() {});
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
                        level: null,
                        status: oldStatus,
                      );
                      await get<SystemViewModel>().getAllUser(context);
                      setState(() => _isBusy = false);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Update Status',
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
