import 'package:flutter/material.dart';
import 'package:frontend/src/widgets/page_container.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockDesktop extends StatelessWidget with GetItMixin {
  StockDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      setSidebarExpanding: true,
      showMenubutton: true,
      mainSection: Container(color: Colors.blueAccent),
    );
  }
}
