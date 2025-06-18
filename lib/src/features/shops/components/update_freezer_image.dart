// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/models/freezer_status.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';

class UpdateFreezerImage extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateFreezerImage({
    super.key,
    required this.freezer,
    required this.selectedStatus,
  });

  final dynamic freezer;
  final Function(FreezerStatus?) selectedStatus;

  @override
  State<UpdateFreezerImage> createState() => _UpdateFreezerImageState();
}

class _UpdateFreezerImageState extends State<UpdateFreezerImage>
    with GetItStateMixin {
  bool _isBusy = false;
  bool _isClient = true;
  final String _errorMessage = "";
  late FreezerStatus _selectedStatus;
  final List<FreezerStatus> _allStatuses = FreezerStatus.values;
  final TextEditingController _freezerDescController = TextEditingController();

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

  Future<bool> _handleUpdate() async {
    String? id =
        get<SystemViewModel>().salesId ??
        (get<SystemViewModel>().subAgentId ?? (get<SystemViewModel>().agentId));

    String clientId = id ?? "";

    bool result = await ApiService().updateFreezerImage(
      context: context,
      id: widget.freezer?['id'] ?? "",
      imageDevice: _imageMobile,
      imageWeb: _imageWeb,
    );

    if (result) {
      if (_isClient) {
        await get<StockViewModel>().getShopsBySales(
          // context: context,
          clientId: clientId,
        );
      } else {
        await get<StockViewModel>().getAllShops(context: context);
      }
      await get<StockViewModel>().getAllFrezer(context);
      return true;
    } else {
      return false;
    }

    // String? id =
    //     get<SystemViewModel>().salesId ??
    //     (get<SystemViewModel>().subAgentId ?? (get<SystemViewModel>().agentId));

    // String clientId = id ?? "";

    // if (_selectedStatus == FreezerStatus.idle) {
    //   bool result = await get<StockViewModel>().returnFreezer(
    //     context: context,
    //     id: widget.freezer?['id'] ?? "",
    //   );

    //   if (result) {
    //     if (_isClient) {
    //       await get<StockViewModel>().getShopsBySales(
    //         // context: context,
    //         clientId: clientId,
    //       );
    //     } else {
    //       await get<StockViewModel>().getAllShops(context: context);
    //     }
    //     await get<StockViewModel>().getAllFrezer(context);
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } else {
    //   bool result = await ApiService().updateFreezerStatus(
    //     context: context,
    //     id: widget.freezer?['id'] ?? "",
    //     status: _selectedStatus.name,
    //     description: _freezerDescController.text,
    //   );

    //   if (result) {
    //     if (_isClient) {
    //       await get<StockViewModel>().getShopsBySales(
    //         // context: context,
    //         clientId: clientId,
    //       );
    //     } else {
    //       await get<StockViewModel>().getAllShops(context: context);
    //     }
    //     await get<StockViewModel>().getAllFrezer(context);
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    _isClient =
        (get<SystemViewModel>().level ?? 0) < 4 ||
        (get<SystemViewModel>().level ?? 0) > 5;
    _selectedStatus = freezerStatusFromString(widget.freezer?['status']);
    _freezerDescController.text = widget.freezer?['description'] ?? "";
    print(widget.freezer);
  }

  @override
  void dispose() {
    super.dispose();
    _freezerDescController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Upload Freezer Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.freezer['name']} (${widget.freezer['serialNumber']})",
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              freezerStatusFromString(widget.freezer['status']).displayName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade600,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),

            // ✅ Image Preview
            _imageMobile != null || _imageWeb != null
                ? Container(
                  height: 120,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child:
                      kIsWeb
                          ? Image.memory(_imageWeb!)
                          : Image.file(File(_imageMobile!.path)),
                )
                : widget.freezer['image'] != null
                ? Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.network(
                    ApplicationInfo.baseUrl + widget.freezer['image'],
                  ),
                )
                : SizedBox(
                  height: 120,
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
            SizedBox(
              height: 18,
              child: Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.redAccent.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),

            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isBusy)
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientElevatedButton(
                      buttonHeight: 30,
                      onPressed: () {
                        setState(() {
                          _selectedStatus = freezerStatusFromString(
                            widget.freezer['status'],
                          );
                        });
                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Batal",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GradientElevatedButton(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade300, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      buttonHeight: 30,
                      onPressed: () async {
                        setState(() => _isBusy = true);
                        bool response = await _handleUpdate();
                        setState(() => _isBusy = false);

                        if (response) {
                          widget.selectedStatus(_selectedStatus);
                          Navigator.pop(context, true);
                        } else {
                          widget.selectedStatus(null);
                          Navigator.pop(context, false);
                        }
                      },
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
