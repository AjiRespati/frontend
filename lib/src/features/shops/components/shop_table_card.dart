// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html; // Wasm-safe

import 'package:get_it_mixin/get_it_mixin.dart';

class ShopTableCard extends StatefulWidget with GetItStatefulWidgetMixin {
  ShopTableCard({
    super.key,
    required this.isMobile,
    required this.isClient,
    required this.shop,
  });

  final Map<String, dynamic> shop;
  final bool isMobile;
  final bool isClient;

  @override
  State<ShopTableCard> createState() => _ShopTableCardState();
}

class _ShopTableCardState extends State<ShopTableCard> with GetItStateMixin {
  bool _isBroken = false;
  String format = 'jpg';
  Uint8List? imageData;
  bool isDownloading = false;

  Future<void> saveImage(Uint8List bytes, String fileName) async {
    // final timestamp = DateTime.now().millisecondsSinceEpoch;
    // final fileName = 'downloaded_image_$timestamp.$format';

    if (kIsWeb) {
      try {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", "$fileName.$format")
          ..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image download started')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download not supported in this environment'),
          ),
        );
      }
    }
    //  else {
    //   final status = await Permission.storage.request();
    //   if (status.isGranted) {
    //     final downloads = Directory('/storage/emulated/0/Download');
    //     final file = File('${downloads.path}/$fileName');
    //     await file.writeAsBytes(bytes);
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(SnackBar(content: Text('Image saved as $fileName')));
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Storage permission denied')),
    //     );
    //   }
    // }
  }

  Future<void> downloadImageAndClosePopup(
    BuildContext dialogContext,
    String imageUrl,
    String fileName,
  ) async {
    Navigator.of(dialogContext).pop();
    setState(() {
      isDownloading = true;
    });
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      setState(() {
        imageData = response.bodyBytes;
        isDownloading = false;
      });
      await saveImage(response.bodyBytes, fileName);
    }
  }

  void showPopup(BuildContext context, String imageUrl, String fileName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.black87,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child:
                    imageData != null
                        ? Image.memory(
                          imageData!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                        : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.blue.shade700),
                      onPressed:
                          () => downloadImageAndClosePopup(
                            dialogContext,
                            imageUrl,
                            fileName,
                          ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.blue.shade700),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setup() {
    List<bool> brokenFreezer = [];
    for (var i = 0; i < (widget.shop['Refrigerators'] ?? []).length; i++) {
      var item = widget.shop['Refrigerators'][i];
      if (item['status'] != null &&
          (item['status'] == 'broken' || item['status'] == 'repairing')) {
        brokenFreezer.add(true);
      }

      _isBroken = brokenFreezer.isNotEmpty;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.reloadBuy);
    _setup();
    return ClipRect(
      child: Banner(
        message: _isBroken ? 'Cek !' : "",
        textStyle: TextStyle(
          color: Colors.red[800],
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
        location: BannerLocation.topEnd,
        color:
            _isBroken
                ? const Color.fromARGB(65, 240, 105, 148)
                : Colors.transparent,
        shadow: BoxShadow(
          color:
              _isBroken
                  ? Color.fromARGB(65, 240, 105, 148)
                  : Colors.transparent,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          // child: InkWell(
          //   onTap: () {
          //     Navigator.pushNamed(
          //       context,
          //       shopsDetailRoute,
          //       arguments: widget.shop,
          //     );
          //   },
          child: SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.shop['image'] != null
                                ? GestureDetector(
                                  onTap:
                                      () => showPopup(
                                        context,
                                        ApplicationInfo.baseUrl +
                                            widget.shop['image'],
                                        widget.shop['name'],
                                      ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Image.network(
                                      ApplicationInfo.baseUrl +
                                          widget.shop['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Icon(
                                    Icons.image,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.shop['name'] ?? " N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      maxLines: 2,
                                      widget.shop['address'] ?? " N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.shop['phone'] ?? " N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.shop['email'] ?? " N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      (widget.shop['status'] ?? " N/A")
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: statusColor(
                                          widget.shop['status'] ?? " N/A",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.shop['Salesman'] != null)
                              Text("Sales: "),
                            if (widget.shop['Salesman'] != null)
                              Text(
                                widget.shop['Salesman']['name'],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            if (widget.shop['SubAgent'] != null)
                              Text("Sales: "),
                            if (widget.shop['SubAgent'] != null)
                              Text(
                                widget.shop['SubAgent']['name'],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            if (widget.shop['Agent'] != null) Text("Sales: "),
                            if (widget.shop['Agent'] != null)
                              Text(
                                widget.shop['Agent']['name'],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Freezer:"),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      widget.shop['Refrigerators'] == null
                                          ? 0
                                          : widget.shop['Refrigerators'].length,
                                  itemBuilder: (context, index) {
                                    var item =
                                        widget.shop['Refrigerators'][index];
                                    return Row(
                                      key: ValueKey(index + 8000),
                                      children: [
                                        Text(
                                          "${item['name']} (${item['serialNumber']})",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            shopsDetailRoute,
                            arguments: widget.shop,
                          );
                        },
                        icon: Icon(Icons.chevron_right_outlined, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ),
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
      case 'inactive':
        return Colors.red.shade400;
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
