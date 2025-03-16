import 'package:flutter/material.dart';
import 'package:frontend/src/features/products/components/product_detail_desktop.dart';
import 'package:frontend/src/features/products/components/product_detail_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: ProductDetailDesktop(),
      mobileLayout: ProductDetailMobile(),
    );
  }
}
