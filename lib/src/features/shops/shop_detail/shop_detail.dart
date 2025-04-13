// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/features/shops/shop_detail/shop_detail_desktop.dart';
import 'package:frontend/src/features/shops/shop_detail/shop_detail_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ShopDetail extends StatefulWidget with GetItStatefulWidgetMixin {
  ShopDetail({required this.shop, super.key});

  final Map<String, dynamic> shop;
  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: ShopDetailDesktop(),
      mobileLayout: ShopDetailMobile(item: widget.shop),
    );
  }
}
