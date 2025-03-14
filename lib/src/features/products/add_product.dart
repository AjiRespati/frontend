import 'package:flutter/material.dart';
import 'package:frontend/src/services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For detecting web

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedMetric = "piece"; // ✅ Default metric
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
      _nameController.text,
      _descriptionController.text,
      int.parse(_amountController.text),
      _selectedMetric,
      double.parse(_priceController.text),
      _imageWeb,
      _imageMobile,
    );

    if (success) {
      Navigator.pop(context);
    } else {
      print("gimana gimana");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create product")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: "Price"),
            keyboardType: TextInputType.number,
          ),

          // ✅ Metric Dropdown
          DropdownButtonFormField<String>(
            value: _selectedMetric,
            onChanged: (newValue) {
              setState(() {
                _selectedMetric = newValue!;
              });
            },
            items:
                ['piece', 'kg', 'gallon', 'liter', 'box', 'bucket'].map((
                  metric,
                ) {
                  return DropdownMenuItem(value: metric, child: Text(metric));
                }).toList(),
            decoration: InputDecoration(labelText: "Metric"),
          ),
          SizedBox(height: 20),

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
              : Icon(Icons.image, size: 100, color: Colors.grey),

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
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text("Upload Image"),
                  onPressed: _pickImageWeb,
                ),
            ],
          ),

          SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: Text("Create Product")),
        ],
      ),
    );
  }
}
