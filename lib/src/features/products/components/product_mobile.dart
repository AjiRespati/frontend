import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/products/components/add_product.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:frontend/src/widgets/mobile_navbar.dart';
import 'package:frontend/src/features/products/components/product_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductMobile extends StatelessWidget with GetItMixin {
  ProductMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          AddButton(
            message: "Add Product",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: 540),
                context: context,
                builder: (context) {
                  return AddProductScreen();
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body:
          watchOnly((StockViewModel x) => x.isLoading)
              ? const Center(child: CircularProgressIndicator())
              : watchOnly((StockViewModel x) => x.products).isEmpty
              ? Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Center(child: Text("No products found")),
                    AddButton(
                      message: "Add Product",
                      onPressed: () {
                        if (kIsWeb) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: SizedBox(
                                  width: 600,
                                  // height: 450,
                                  child: AddProductScreen(),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height:
                          (MediaQuery.of(context).size.height - 152) -
                          (kIsWeb ? 0 : 50),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // ✅ 2 Columns
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.7, // ✅ Adjust aspect ratio
                            ),
                        itemCount: get<StockViewModel>().products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: get<StockViewModel>().products[index],
                            isMobile: true,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
