// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddClient extends StatefulWidget with GetItStatefulWidgetMixin {
  AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> with GetItStateMixin {
  final List<String> _clientType = ["Salesman", "Sub Agent", "Agent"];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedClient = "Salesman"; // ✅ Default
  final ApiService apiService = ApiService();

  // ✅ Submit Form
  void _submit() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 230,
            child: Column(
              children: [
                SizedBox(height: 30),
                Icon(Icons.error_outline, size: 38, color: Colors.amber),
                SizedBox(height: 10),
                Text(
                  "Anda akan menambahkan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  _selectedClient,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 70,
                      child: GradientElevatedButton(
                        inactiveDelay: Duration.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 40,
                      width: 70,
                      child: GradientElevatedButton(
                        inactiveDelay: Duration.zero,
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(30, 241, 107, 1),
                            Colors.green,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value == true) {
        switch (_selectedClient) {
          case "Salesman":
            _submitSalesman();
            break;
          case "Sub Agent":
            _submitSubAgent();
            break;
          default:
            _submitAgent();
        }
      }
    });
  }

  void _submitSalesman() async {
    bool success = await apiService.createSalesman(
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    if (success) {
      await get<StockViewModel>().fetchSalesmen(isInitial: false);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create salesman")));
    }
  }

  void _submitSubAgent() async {
    bool success = await apiService.createSubAgent(
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    if (success) {
      await get<StockViewModel>().fetchSubAgents(isInitial: false);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create sub agent")));
    }
  }

  void _submitAgent() async {
    bool success = await apiService.createAgent(
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    if (success) {
      await get<StockViewModel>().fetchAgents(isInitial: false);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create agent")));
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedClient = _clientType[get<StockViewModel>().clientTabIndex];
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
                _clientType.map((metric) {
                  return DropdownMenuItem(value: metric, child: Text(metric));
                }).toList(),
            decoration: InputDecoration(
              labelText: "Client Type",
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
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
          GradientElevatedButton(
            inactiveDelay: Duration.zero,
            onPressed: _submit,
            child: Text(
              "Add Client",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
