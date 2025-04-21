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

class AddProductScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with GetItStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedMetric = "carton"; // ✅ Default metric
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
    bool success = await apiService.createProduct(
      context: context,
      name: _nameController.text,
      description: _descriptionController.text,
      metric: _selectedMetric,
      price: double.parse(_priceController.text),
      imageWeb: _imageWeb,
      imageDevice: _imageMobile,
    );

    if (success) {
      await get<StockViewModel>().fetchProducts(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create product")));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          // ✅ Image Preview
          _imageMobile != null || _imageWeb != null
              ? Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child:
                    kIsWeb
                        ? Image.memory(_imageWeb!)
                        : Image.file(File(_imageMobile!.path)),
              )
              : SizedBox(
                height: 150,
                width: 150,
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),

          SizedBox(height: 10),

          // ✅ Pick Image Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!kIsWeb) // ✅ Mobile: Camera & Gallery
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Camera"),
                  onPressed: () => _pickImageMobile(ImageSource.camera),
                ),
              if (!kIsWeb) SizedBox(width: 10),
              if (!kIsWeb)
                ElevatedButton.icon(
                  icon: Icon(Icons.photo),
                  label: Text("Gallery"),
                  onPressed: () => _pickImageMobile(ImageSource.gallery),
                ),
              if (kIsWeb) // ✅ Web: File Picker
                GradientElevatedButton(
                  onPressed: _pickImageWeb,
                  buttonHeight: 30,
                  gradient: LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.green[800] ?? Colors.greenAccent,
                    ],
                  ),
                  // inactiveDelay: Duration.zero,
                  child: Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: "Price"),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 4),

          // ✅ Metric Dropdown
          DropdownButtonFormField<String>(
            value: _selectedMetric,
            onChanged: (newValue) {
              setState(() {
                _selectedMetric = newValue!;
              });
            },
            items:
                get<StockViewModel>().measurements.map((metric) {
                  return DropdownMenuItem(value: metric, child: Text(metric));
                }).toList(),
            decoration: InputDecoration(labelText: "Metric"),
          ),
          SizedBox(height: 30),
          GradientElevatedButton(
            onPressed: _submit,
            child: Text(
              "Add Product",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
