// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For detecting web

class AddClient extends StatefulWidget with GetItStatefulWidgetMixin {
  AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> with GetItStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedClient = "Salesman"; // ✅ Default metric
  final ApiService apiService = ApiService();

  XFile? _imageMobile;
  Uint8List? _imageWeb;
  final ImagePicker _picker = ImagePicker();

  // ✅ Pick Image for Mobile
  Future<void> _pickImageMobile(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    setState(() {
      _imageMobile = pickedImage;
    });
  }

  // ✅ Pick Image for Web
  Future<void> _pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _imageWeb = result.files.first.bytes;
      });
    }
  }

  // ✅ Submit Form
  void _submit() async {
    bool success = await apiService.createSalesman(
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    if (success) {
      await get<StockViewModel>().fetchSalesmen();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create salesman")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Add Clients",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),

          // ✅ Client Type Dropdown
          DropdownButtonFormField<String>(
            value: _selectedClient,
            onChanged: (newValue) {
              setState(() {
                _selectedClient = newValue!;
              });
            },
            items:
                ["Salesman", "Sub Agent", "Agent"].map((metric) {
                  return DropdownMenuItem(value: metric, child: Text(metric));
                }).toList(),
            decoration: InputDecoration(labelText: "Client Type"),
          ),

          SizedBox(height: 10),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: "Address"),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: "Phone"),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          SizedBox(height: 40),
          GradientElevatedButton(onPressed: _submit, child: Text("Add Client")),
        ],
      ),
    );
  }
}
