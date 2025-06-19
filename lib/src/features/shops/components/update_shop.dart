// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/shops/components/update_freezer_image.dart';
import 'package:frontend/src/features/shops/components/update_freezer_status.dart';
import 'package:frontend/src/models/freezer_status.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';

class UpdateShop extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateShop({required this.shop, super.key});
  final Map<String, dynamic> shop;

  @override
  State<UpdateShop> createState() => _UpdateShopState();
}

class _UpdateShopState extends State<UpdateShop> with GetItStateMixin {
  final ApiService apiService = ApiService();
  dynamic _selectedFrezer;
  String oldStatus = "ACTIVE";
  String? _message;
  final String _errorMessage = "";
  bool _isClient = true;

  String? _salesman;
  String? _subAgent;
  String? _agent;
  String? _salesmanId;
  String? _subAgentId;
  String? _agentId;

  bool _isNoSales = false;

  List<dynamic> _salesmen = [];
  final List<String> _salesmenNames = [];
  List<dynamic> _subAgents = [];
  final List<String> _subAgentNames = [];
  List<dynamic> _agents = [];
  final List<String> _agentNames = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  void _submit() async {
    var shopInfo = widget.shop;
    var freezerInfo = _selectedFrezer;
    if (freezerInfo != null) {
      await get<StockViewModel>().updateFreezerShop(
        context: context,
        id: freezerInfo['id'],
        shopId: shopInfo['id'],
        status: "active",
      );
    }

    await get<StockViewModel>().updateShop(
      context: context,
      id: shopInfo['id'],
      salesId: _salesmanId,
      subAgentId: _subAgentId,
      agentId: _agentId,
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      address:
          _addressController.text.isNotEmpty ? _addressController.text : null,
      coordinates: null,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      email: _emailController.text.isNotEmpty ? _emailController.text : null,
      status: oldStatus.toLowerCase(),
      imageWeb: _imageWeb,
      imageDevice: _imageMobile,
    );

    await get<StockViewModel>().getAllShops(context: context);
    Navigator.pushNamed(context, shopsRoute);
  }

  Future<void> _setup() async {
    final Map<String, dynamic> shop = widget.shop;
    _nameController.text = shop['name'];
    _addressController.text = shop['address'];
    _phoneController.text = shop['phone'];
    _emailController.text = shop['email'];
    _salesmen = get<StockViewModel>().salesmen;
    for (var i = 0; i < _salesmen.length; i++) {
      _salesmenNames.add(_salesmen[i]['name']);
    }

    _subAgents = get<StockViewModel>().subAgents;
    for (var i = 0; i < _subAgents.length; i++) {
      _subAgentNames.add(_subAgents[i]['name']);
    }

    _agents = get<StockViewModel>().agents;
    for (var i = 0; i < _agents.length; i++) {
      _agentNames.add(_agents[i]['name']);
    }

    _isNoSales =
        shop['Salesman'] == null &&
        shop['SubAgent'] == null &&
        shop['Agent'] == null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // print(widget.shop);
    oldStatus = widget.shop["status"].toString().toUpperCase();
    _isClient =
        (get<SystemViewModel>().level ?? 0) < 4 ||
        (get<SystemViewModel>().level ?? 0) > 5;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.shops);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Edit Toko",
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "${widget.shop['name']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            "${(widget.shop['status'] ?? "").toUpperCase()}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: statusColor(widget.shop['status'] ?? ""),
            ),
          ),
          if (!_isClient && _isNoSales)
            Text(
              "Tanpa Sales",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          SizedBox(height: 15),
          Divider(),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ✅ INI DAFTAR REFRIGERATOR
                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.shop['Refrigerators'] == null
                              ? 0
                              : widget.shop['Refrigerators'].length,
                      itemBuilder: (context, index) {
                        var freezer = widget.shop['Refrigerators'][index];
                        var freezerStatus = freezer['status'];
                        return Padding(
                          key: ValueKey(index + 9000),
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${freezer['name']} (${freezer['serialNumber']})",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    freezerStatusFromString(
                                      freezerStatus,
                                    ).displayName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: statusColor(freezerStatus),
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  InkWell(
                                    onTap: () async {
                                      bool? result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: UpdateFreezerStatus(
                                              freezer: freezer,
                                              selectedStatus: (newStatus) {
                                                setState(() {
                                                  freezerStatus =
                                                      newStatus?.name;
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      );
                                      if (result == true) {
                                        get<StockViewModel>().reloadBuy = true;
                                        setState(() {
                                          _message =
                                              "Berhasil update status freezer";
                                        });
                                        await Future.delayed(
                                          Durations.extralong4,
                                        );
                                        get<StockViewModel>().reloadBuy = null;

                                        setState(() {
                                          _message = null;
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else if (result == false) {
                                        setState(() {
                                          _message =
                                              "Update status freezer tidak berhasil";
                                        });
                                        await Future.delayed(
                                          Durations.extralong4,
                                        );
                                        setState(() {
                                          _message = null;
                                        });
                                      } else {
                                        setState(() {
                                          _message = "test";
                                        });
                                        await Future.delayed(
                                          Durations.extralong4,
                                        );
                                        setState(() {
                                          _message = null;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.edit, size: 18),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      bool? result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: UpdateFreezerImage(
                                              freezer: freezer,
                                              selectedStatus: (newStatus) {
                                                setState(() {
                                                  freezerStatus =
                                                      newStatus?.name;
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      );
                                      if (result == true) {
                                        get<StockViewModel>().reloadBuy = true;
                                        setState(() {
                                          _message =
                                              "Berhasil update status freezer";
                                        });
                                        await Future.delayed(
                                          Durations.extralong4,
                                        );
                                        get<StockViewModel>().reloadBuy = null;

                                        setState(() {
                                          _message = null;
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else if (result == false) {
                                        setState(() {
                                          _message =
                                              "Update status freezer tidak berhasil";
                                        });
                                        await Future.delayed(
                                          Durations.extralong4,
                                        );
                                        setState(() {
                                          _message = null;
                                        });
                                      } else {
                                        setState(() {
                                          _message = "test";
                                        });
                                        await Future.delayed(
                                          Durations.extralong4,
                                        );
                                        setState(() {
                                          _message = null;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.image, size: 18),
                                  ),
                                ],
                              ),
                              Row(
                                children: [Text(freezer['description'] ?? "")],
                              ),

                              freezer['image'] != null
                                  ? Container(
                                    height: 120,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Image.network(
                                      ApplicationInfo.baseUrl +
                                          freezer['image'],
                                    ),
                                  )
                                  : SizedBox(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  //TODO: AWAL ADMIN AREA
                  if (!_isClient) Row(children: [Text("Kirim Freezer")]),
                  if (!_isClient)
                    DropdownSearch<dynamic>(
                      decoratorProps: DropDownDecoratorProps(
                        baseStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ), // Style for text inside the closed dropdown
                      ),
                      popupProps: PopupProps.menu(
                        // Or .dialog(), .modalBottomSheet(), .menu()
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            hintText: "Cari freezer...",
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                        ),
                        itemBuilder: _customPopupItemBuilder,
                      ),
                      // *** Core properties (mostly unchanged in how they are used) ***
                      items:
                          (filter, loadProps) =>
                              get<StockViewModel>()
                                  .idleFreezers, // The list of items
                      onChanged: (dynamic newValue) {
                        // Callback when an item is selected
                        setState(() {
                          _selectedFrezer = newValue;
                          // print("Selected shop: $_selectedFrezer");
                        });
                      },
                      selectedItem:
                          _selectedFrezer, // The currently selected item
                      // *** Optional: Customize the display of the selected item when closed ***
                      // This builder is still valid at the top level
                      dropdownBuilder: (context, selectedItem) {
                        if (selectedItem == null) {
                          // Use hint style from decoration if available and item is null
                          final hintStyle =
                              Theme.of(
                                context,
                              ).inputDecorationTheme.hintStyle ??
                              TextStyle(color: Colors.grey[600]);
                          return Text("Pilih freezer", style: hintStyle);
                        }
                        return Text(
                          "${selectedItem['name']} (${selectedItem['serialNumber']})",
                        );
                      },
                      filterFn: (item, filter) {
                        // Optional: Custom filter logic
                        if (filter.isEmpty)
                          return true; // Show all if search is empty
                        // Case-insensitive search
                        return item['name'].toLowerCase().contains(
                          filter.toLowerCase(),
                        );
                      },
                      compareFn: (item1, item2) => item1['id' == item2['id']],
                    ),

                  SizedBox(height: 10),
                  if (!_isClient) Row(children: [Text("Update Status Toko")]),
                  if (!_isClient)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(isDense: true),
                      value: oldStatus,
                      items:
                          ["ACTIVE", "INACTIVE"].map((item) {
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
                  if (!_isClient && _isNoSales) SizedBox(height: 30),
                  if (!_isClient && _isNoSales) Text("Tugaskan Sales"),
                  if (!_isClient && _isNoSales) SizedBox(height: 10),
                  if (!_isClient && _isNoSales)
                    Row(children: [Text("Salesman")]),
                  if (!_isClient && _isNoSales)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(isDense: true),
                      value: _salesman,
                      items:
                          _salesmenNames.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        _salesman = value;
                        _subAgent = null;
                        _agent = null;

                        String? id;
                        int idx = _salesmenNames.indexOf(value ?? "");
                        if (idx >= 0) {
                          id = _salesmen[idx]['id'];
                        }

                        _salesmanId = id;
                        _subAgentId = null;
                        _agentId = null;

                        setState(() {});
                      },
                    ),
                  if (!_isClient && _isNoSales) SizedBox(height: 10),
                  if (!_isClient && _isNoSales)
                    Row(children: [Text("Sub Agent")]),
                  if (!_isClient && _isNoSales)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(isDense: true),
                      value: _subAgent,
                      items:
                          _subAgentNames.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        _salesman = null;
                        _subAgent = value;
                        _agent = null;

                        String? id;
                        int idx = _subAgentNames.indexOf(value ?? "");
                        if (idx >= 0) {
                          id = _subAgents[idx]['id'];
                        }

                        _salesmanId = null;
                        _subAgentId = id;
                        _agentId = null;

                        setState(() {});
                      },
                    ),
                  if (!_isClient && _isNoSales) SizedBox(height: 10),
                  if (!_isClient && _isNoSales) Row(children: [Text("Agent")]),
                  if (!_isClient && _isNoSales)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(isDense: true),
                      value: _agent,
                      items:
                          _agentNames.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        _salesman = null;
                        _subAgent = null;
                        _agent = value;

                        String? id;
                        int idx = _agentNames.indexOf(value ?? "");
                        if (idx >= 0) {
                          id = _agents[idx]['id'];
                        }

                        _salesmanId = null;
                        _subAgentId = null;
                        _agentId = id;

                        setState(() {});
                      },
                    ),

                  Stack(
                    children: [
                      SizedBox(height: 40),
                      if (_message != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _message ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      (_message ?? "").contains('tidak')
                                          ? Colors.red.shade600
                                          : Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  //TODO: AKHIR ADMIN AREA
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
                      : widget.shop['image'] != null
                      ? Container(
                        height: 120,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.network(
                          ApplicationInfo.baseUrl + widget.shop['image'],
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
                          onPressed:
                              () => _pickImageMobile(ImageSource.gallery),
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

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Nama Toko: "),
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
                    decoration: InputDecoration(labelText: "Alamat: "),
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
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: "Telepon: "),
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
                    decoration: InputDecoration(labelText: "Email: "),
                  ),
                  SizedBox(height: 4),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),

          if (!_isClient)
            Stack(
              alignment: Alignment.center,
              children: [
                GradientElevatedButton(
                  // inactiveDelay: Duration.zero,
                  onPressed: _submit,
                  child: Text(
                    "Update Toko",
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
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          if (_isClient)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GradientElevatedButton(
                  // inactiveDelay: Duration.zero,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GradientElevatedButton(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: _submit,
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 10),
                      Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    dynamic item,
    bool isDisabled,
    bool isSelected,
  ) {
    // --- You can now use the 'isDisabled' flag ---
    Color textColor = Colors.black87; // Default text color
    FontWeight fontWeight = FontWeight.normal;

    if (isDisabled) {
      textColor =
          Colors.grey; // Style disabled items differently (e.g., greyed out)
    } else if (isSelected) {
      textColor = Theme.of(context).primaryColor; // Highlight selected
      fontWeight = FontWeight.bold;
    }
    // --- End of using 'isDisabled' ---

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // You might want to prevent interaction if isDisabled is true,
      // though the dropdown often handles this already.
      child: Text(
        "${item['name']} (${item['serialNumber']})",
        style: TextStyle(
          fontSize: 16,
          color: textColor, // Use the determined color
          fontWeight: fontWeight, // Use the determined weight
          // decoration: isDisabled ? TextDecoration.lineThrough : null, // Optional: strike-through
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'idle':
        return Colors.amberAccent.shade700;
      case 'active':
        return Colors.green.shade700;
      case 'broken':
        return Colors.red.shade700;
      case 'repairing':
        return Colors.red.shade400;
      case 'wasted':
        return Colors.blueGrey.shade900;
      default:
        return Colors.black;
    }
  }
}
