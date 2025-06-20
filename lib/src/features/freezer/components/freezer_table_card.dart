// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/freezer/components/update_freezer.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html; // Wasm-safe

class FreezerTableCard extends StatefulWidget with GetItStatefulWidgetMixin {
  FreezerTableCard({super.key, required this.isMobile, required this.freezer});

  final Map<String, dynamic> freezer;
  final bool isMobile;

  @override
  State<FreezerTableCard> createState() => _FreezerTableCardState();
}

class _FreezerTableCardState extends State<FreezerTableCard>
    with GetItStateMixin {
  String format = 'jpg';
  Uint8List? imageData;
  bool isDownloading = false;

  Future<void> saveImage(Uint8List bytes, String name) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${name}_$timestamp.$format';

    if (kIsWeb) {
      try {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
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
    String name,
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
      await saveImage(response.bodyBytes, name);
    }
  }

  void showPopup(BuildContext context, String imageUrl, String name) {
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
                            name,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      // child: InkWell(
      //   onTap: () async {
      //     showModalBottomSheet(
      //       isScrollControlled: true,
      //       constraints: BoxConstraints(maxHeight: 640),
      //       context: context,
      //       builder: (context) {
      //         return Padding(
      //           padding: EdgeInsets.only(
      //             bottom: MediaQuery.of(context).viewInsets.bottom,
      //           ),
      //           child: SingleChildScrollView(
      //             child: UpdateFreezer(freezer: widget.freezer),
      //           ),
      //         );
      //       },
      //     );
      //   },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.freezer['image'] != null
                ? GestureDetector(
                  onTap:
                      () => showPopup(
                        context,
                        ApplicationInfo.baseUrl + widget.freezer['image'],
                        "${widget.freezer['name']} - ${widget.freezer['serialNumber']}",
                      ),
                  child: Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.network(
                      ApplicationInfo.baseUrl + widget.freezer['image'],
                    ),
                  ),
                )
                : SizedBox(
                  height: 90,
                  width: 80,
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.freezer['name'] ?? " N/A",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        flex: 3,
                        child: Text(
                          widget.freezer['serialNumber'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.freezer['capacity'] ?? " N/A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (widget.freezer['status'] ?? "N/A").toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor(widget.freezer['status']),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.freezer['Shop']?['name'] ?? " -",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.freezer['Shop']?['address'] ?? " -",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
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
                  onPressed: () async {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      constraints: BoxConstraints(maxHeight: 640),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: UpdateFreezer(freezer: widget.freezer),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.chevron_right_outlined, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }

  // "idle", "active", "broken", "wasted"
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
