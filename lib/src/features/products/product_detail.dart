import 'package:flutter/material.dart';
import 'package:frontend/src/features/products/components/product_detail_desktop.dart';
import 'package:frontend/src/features/products/components/product_detail_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductDetail extends StatefulWidget with GetItStatefulWidgetMixin {
  ProductDetail({required this.productId, super.key});

  final String productId;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> with GetItStateMixin {
  _setup() async {
    get<StockViewModel>().fetchProduct(widget.productId);
    // get<StockViewModel>().fetchStockByProduct(widget.productId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: ProductDetailDesktop(),
      mobileLayout: ProductDetailMobile(),
    );
  }
}
