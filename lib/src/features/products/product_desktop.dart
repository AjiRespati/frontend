import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/products/components/add_product.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/page_container.dart';
import 'package:frontend/src/features/products/components/product_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductDesktop extends StatelessWidget with GetItMixin {
  ProductDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection:
            watchOnly((StockViewModel x) => x.isBusy)
                ? const Center(child: CircularProgressIndicator())
                : get<StockViewModel>().products.isEmpty
                ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      const Center(child: Text("No products found")),
                      GradientElevatedButton(
                        onPressed: () {
                          if (kIsWeb) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  child: AddProductScreen(),
                                );
                              },
                            );
                          }
                          // Navigator.pushNamed(context, addProductsRoute);
                        },
                        child: Text(
                          "Add Products",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 80),
                          Text(
                            "Products",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          GradientElevatedButton(
                            buttonHeight: 33,
                            onPressed: () {
                              if (kIsWeb) {
                                showDialog(
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
                              // Navigator.pushNamed(context, addProductsRoute);
                            },
                            child: Text(
                              "Add Product",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 80),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // ✅ 4 Columns
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 0.75, // ✅ Adjust aspect ratio
                              ),
                          itemCount: get<StockViewModel>().products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: get<StockViewModel>().products[index],
                              isMobile: false,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        // infoSection: SizedBox(),
      ),
    );
  }
}
