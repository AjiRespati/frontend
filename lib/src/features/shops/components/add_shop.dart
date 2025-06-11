// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddShop extends StatefulWidget with GetItStatefulWidgetMixin {
  AddShop({super.key});

  @override
  State<AddShop> createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> with GetItStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ApiService apiService = ApiService();

  String _errorMessage = "";

  void _submit() async {
    String? salesId = get<SystemViewModel>().salesId;
    String? subAgentId = get<SystemViewModel>().subAgentId;
    String? agentId = get<SystemViewModel>().agentId;

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      //  || _emailController.text.isEmpty) {
      setState(() {
        _errorMessage = "Data belum lengkap.";
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _errorMessage = "";
      });
    } else {
      await get<StockViewModel>().createShop(
        salesId: salesId,
        subAgentId: subAgentId,
        agentId: agentId,
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email:
            _emailController.text.isEmpty
                ? "${_nameController.text.replaceAll(" ", "").toLowerCase().trim()}@mail.com"
                : _emailController.text,
        imageUrl: null,
        coordinates: null,
      );
      // await get<StockViewModel>().getShopsBySales(
      //   context: context,
      //   clientId: salesId ?? (subAgentId ?? (agentId ?? "")),
      // );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Tambah Toko",
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
            minLines: 1,
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
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 4),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              helperText: "Tidak wajib diisi",
            ),
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return "Harus diisi";
            //   }
            //   return null;
            // },
            autovalidateMode: AutovalidateMode.always,
          ),
          SizedBox(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _errorMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientElevatedButton(
                    // inactiveDelay: Duration.zero,
                    onPressed: _submit,
                    child: Text(
                      "Tambah Toko",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                        child: CircularProgressIndicator(color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
