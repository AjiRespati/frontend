// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddFreezer extends StatefulWidget with GetItStatefulWidgetMixin {
  AddFreezer({super.key});

  @override
  State<AddFreezer> createState() => _AddFreezerState();
}

class _AddFreezerState extends State<AddFreezer> with GetItStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ApiService apiService = ApiService();

  void _submit() async {
    String salesId = get<SystemViewModel>().salesId ?? "-";
    await get<StockViewModel>().createShop(
      salesId: salesId,
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      imageUrl: null,
      coordinates: null,
    );
    await get<StockViewModel>().getShopsBySales(salesId: salesId);

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

          // ✅ Client Type Dropdown
          // DropdownButtonFormField<String>(
          //   value: _selectedClient,
          //   onChanged: (newValue) {
          //     setState(() {
          //       _selectedClient = newValue!;
          //     });
          //   },
          //   items:
          //       _clientType.map((metric) {
          //         return DropdownMenuItem(value: metric, child: Text(metric));
          //       }).toList(),
          //   decoration: InputDecoration(
          //     labelText: "Client Type",
          //     labelStyle: TextStyle(
          //       fontWeight: FontWeight.w600,
          //       color: Colors.red[600],
          //     ),
          //   ),
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.red[700],
          //   ),
          // ),
          SizedBox(height: 10),

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Nama Toko"),
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
            controller: _addressController,
            maxLines: 3,
            decoration: InputDecoration(labelText: "Alamat"),
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
            controller: _phoneController,
            decoration: InputDecoration(labelText: "Telepon"),
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
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Harus diisi";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          SizedBox(height: 40),
          Stack(
            children: [
              GradientElevatedButton(
                inactiveDelay: Duration.zero,
                onPressed: _submit,
                child: Text(
                  "Tambah Toko",
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
