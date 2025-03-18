import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboard extends StatefulWidget {
  const CopyToClipboard(this.text, {this.isMobile, this.isSkeleton, super.key});
  final String text;
  final bool? isMobile;
  final bool? isSkeleton;

  @override
  State<CopyToClipboard> createState() => _CopyToClipboardState();
}

class _CopyToClipboardState extends State<CopyToClipboard> {
  bool _isMessageShown = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: isMobile == true ? 21 : 23,
      // height: widget.isSkeleton == true ? 23 : 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.isMobile == true ? 20 : 23,
            height: widget.isMobile == true ? 20 : 23,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                elevation: WidgetStateProperty.all(2),
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                Clipboard.setData(ClipboardData(text: widget.text));
                setState(() => _isMessageShown = true);
                Future.delayed(
                  const Duration(seconds: 1),
                  () => setState(() => _isMessageShown = false),
                );
              },
              child: Icon(
                Icons.copy,
                size: widget.isMobile == true ? 16 : 20,
                color: Colors.black,
              ),
            ),
          ),
          _isMessageShown
              ? Card(
                child: Icon(
                  Icons.check,
                  size: widget.isMobile == true ? 16 : 20,
                  color: Colors.green[600],
                ),
              )
              : Card(
                elevation: 0,
                color: Colors.transparent,
                child: Icon(
                  Icons.check,
                  size: widget.isMobile == true ? 16 : 20,
                  color: Colors.transparent,
                ),
              ),
        ],
      ),
    );
  }
}
