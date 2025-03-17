import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/products/components/stock_card.dart';
import 'package:frontend/src/features/stock/components/add_stock.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductDetailMobile extends StatelessWidget with GetItMixin {
  ProductDetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic mainProduct;
    List<dynamic>? stocks;
    if (watchOnly((StockViewModel x) => x.productsDetail) == null) {
    } else if ((get<StockViewModel>().productsDetail!.isNotEmpty)) {
      mainProduct = get<StockViewModel>().productsDetail![0];
    }
    if (watchOnly((StockViewModel x) => x.stock) == null) {
    } else {
      stocks = get<StockViewModel>().stock;
    }

    String imageUrl = ApplicationInfo.baseUrl + (mainProduct?['image'] ?? '');
    print("PRODUCT: ${get<StockViewModel>().productsDetail}");
    print("STOCKS: ${get<StockViewModel>().stock}");
    return Scaffold(
      appBar: AppBar(title: Text("Product Detail")),
      body:
          watchOnly((StockViewModel x) => x.productsDetail) == null
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
              : Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      mainProduct['productName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: SizedBox(
                        height: 160,
                        width: 160 * 4 / 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                            bottom: Radius.circular(10),
                          ),
                          child:
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            ),
                                  )
                                  : const Icon(Icons.image, size: 50),
                        ),
                      ),
                    ),
                    Text(mainProduct['description']),
                    SizedBox(height: 10),
                    stocks == null || stocks.isEmpty
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 40),
                            SizedBox(
                              height: 30,
                              // width: 30,
                              child: GradientElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(maxHeight: 540),
                                    context: context,
                                    builder: (context) {
                                      return AddStock(
                                        mainProduct: mainProduct,
                                        measurements: [
                                          "kg",
                                          "g",
                                          "liter",
                                          "bucket",
                                          "carton",
                                          "box",
                                          "pcs",
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("Initialize Stock"),
                              ),
                            ),
                          ],
                        )
                        : SizedBox(
                          height: MediaQuery.of(context).size.height - 320,
                          child: ListView.builder(
                            itemCount:
                                get<StockViewModel>().productsDetail!.length,
                            itemBuilder: (context, index) {
                              var product =
                                  get<StockViewModel>().productsDetail![index];
                              return StockCard(
                                product: product,
                                stock: stocks!,
                              );
                            },
                          ),
                        ),
                  ],
                ),
              ),
    );
  }
}
