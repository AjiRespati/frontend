// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddFreezer extends StatefulWidget with GetItStatefulWidgetMixin {
  AddFreezer({super.key});

  @override
  State<AddFreezer> createState() => _AddFreezerState();
}

class _AddFreezerState extends State<AddFreezer> with GetItStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final ApiService apiService = ApiService();

  void _submit() async {
    await get<StockViewModel>().addRefrigerator(
      context: context,
      name: _nameController.text,
      capacity: _capacityController.text,
      serialNumber: _serialNumberController.text,
      coordinates: null,
    );
    await get<StockViewModel>().getAllFrezer(context);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Tambah Freezer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          SizedBox(height: 10),

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Merek Freezer: "),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Harus diisi";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: _capacityController,
            decoration: InputDecoration(labelText: "Kapasitas"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Harus diisi";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: _serialNumberController,
            decoration: InputDecoration(labelText: "Serial Number"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Harus diisi";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
          ),
          SizedBox(height: 40),
          Stack(
            children: [
              GradientElevatedButton(
                // inactiveDelay: Duration.zero,
                onPressed: _submit,
                child: Text(
                  "Tambah Freezer",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  if (watchOnly((StockViewModel x) => x.isBusy))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
