import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';

class AddWarehouseScreen extends StatefulWidget {
  const AddWarehouseScreen({super.key});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final ApiService apiService = ApiService();

  void _submit() async {
    bool success = await apiService.createWarehouse(
      _nameController.text,
      _addressController.text,
      _phoneController.text,
      _emailController.text,
      _contactPersonController.text,
      "get_user_from_jwt",
    );

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Warehouse Created!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to create warehouse")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Warehouse")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Address")),
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone")),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: _contactPersonController,
                decoration: InputDecoration(labelText: "Contact Person")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text("Create Warehouse")),
          ],
        ),
      ),
    );
  }
}
