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
  // final ApiService apiService = ApiService();
  // List<dynamic> products = [];
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    get<StockViewModel>().fetchProducts();
  }

  // void _fetchProducts() async {
  //   List<dynamic> data = await apiService.fetchProducts();
  //   setState(() {
  //     products = data;
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: ProductMobile(),
      desktopLayout: ProductDesktop(),
    );
    // return Scaffold(
    //   body: PageContainer(
    //     setSidebarExpanding: true,
    //     showMenubutton: true,
    //     mainSection:
    //         isLoading
    //             ? const Center(child: CircularProgressIndicator())
    //             : products.isEmpty
    //             ? Padding(
    //               padding: const EdgeInsets.all(20),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   SizedBox(),
    //                   const Center(child: Text("No products found")),
    //                   GradientElevatedButton(
    //                     onPressed: () {
    //                       if (kIsWeb) {
    //                         showDialog(
    //                           context: context,
    //                           builder: (context) {
    //                             return Dialog(
    //                               backgroundColor: Colors.white,
    //                               child: AddProductScreen(),
    //                             );
    //                           },
    //                         );
    //                       }
    //                       // Navigator.pushNamed(context, addProductsRoute);
    //                     },
    //                     child: Text(
    //                       "Add Products",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //             : Column(
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(left: 10, top: 20, right: 10),
    //                   child: Row(
    //                     children: [
    //                       SizedBox(width: 80),
    //                       Text(
    //                         "Products",
    //                         style: TextStyle(
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 20,
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       GradientElevatedButton(
    //                         buttonHeight: 33,
    //                         onPressed: () {
    //                           if (kIsWeb) {
    //                             showDialog(
    //                               context: context,
    //                               builder: (context) {
    //                                 return Dialog(
    //                                   backgroundColor: Colors.white,
    //                                   child: SizedBox(
    //                                     width: 600,
    //                                     // height: 450,
    //                                     child: AddProductScreen(),
    //                                   ),
    //                                 );
    //                               },
    //                             );
    //                           }
    //                           // Navigator.pushNamed(context, addProductsRoute);
    //                         },
    //                         child: Text(
    //                           "Add Product",
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                       ),
    //                       SizedBox(width: 80),
    //                     ],
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: SizedBox(
    //                     height: MediaQuery.of(context).size.height,
    //                     child: GridView.builder(
    //                       gridDelegate:
    //                           const SliverGridDelegateWithFixedCrossAxisCount(
    //                             crossAxisCount: 4, // ✅ 4 Columns
    //                             crossAxisSpacing: 8.0,
    //                             mainAxisSpacing: 8.0,
    //                             childAspectRatio: 0.75, // ✅ Adjust aspect ratio
    //                           ),
    //                       itemCount: products.length,
    //                       itemBuilder: (context, index) {
    //                         return ProductCard(product: products[index]);
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //     // infoSection: SizedBox(),
    //   ),
    // );
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
