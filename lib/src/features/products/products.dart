import 'package:flutter/material.dart';
import 'package:frontend/src/features/products/product_desktop.dart';
import 'package:frontend/src/features/products/product_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Products extends StatefulWidget with GetItStatefulWidgetMixin {
  Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<StockViewModel>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: ProductMobile(),
      desktopLayout: ProductDesktop(),
    );
  }
}

/// CONTOH INFINITE VIEW
class InfiniteGridView extends StatefulWidget {
  const InfiniteGridView({super.key});

  @override
  State<InfiniteGridView> createState() => _InfiniteGridViewState();
}

class _InfiniteGridViewState extends State<InfiniteGridView> {
  List<IconData> icons = [];

  @override
  void initState() {
    super.initState();
    retrieveIcons();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: icons.length,
      itemBuilder: ((context, index) {
        if (index == icons.length - 1 && icons.length < 200) {
          retrieveIcons();
        }
        return Icon(icons[index]);
      }),
    );
  }

  void retrieveIcons() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      setState(() {
        icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast,
        ]);
      });
    });
  }
}
