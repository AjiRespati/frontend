import 'package:flutter/material.dart';
import 'package:frontend/application_info.dart';
import 'package:frontend/src/features/products/components/product_detail_card.dart';
import 'package:frontend/src/features/products/components/create_product_measurement.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/widgets/buttons/add_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ProductDetailMobile extends StatelessWidget with GetItMixin {
  ProductDetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic mainProduct;
    // List<dynamic>? stocks;
    watchOnly((StockViewModel x) => x.productsDetail);
    if (get<StockViewModel>().productsDetail != null &&
        get<StockViewModel>().productsDetail!.isNotEmpty) {
      mainProduct = get<StockViewModel>().productsDetail![0];
    }
    // if (watchOnly((StockViewModel x) => x.stock) == null) {
    // } else {
    //   stocks = get<StockViewModel>().stock;
    // }

    String imageUrl = ApplicationInfo.baseUrl + (mainProduct?['image'] ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Detail",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          if (watchOnly((StockViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
        ],
      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        Flexible(
                          child: Text(
                            mainProduct['productName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue[900],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
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
                    SizedBox(height: 2),
                    Text(mainProduct['description']),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Tambah Jenis Ukuran Unit"),
                        SizedBox(width: 10),
                        AddButton(
                          color: Colors.amber[700],
                          size: 24,
                          message: "Add Product Measurement",
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              constraints: BoxConstraints(maxHeight: 340),
                              context: context,
                              builder: (context) {
                                return CreateProductMeasurement(
                                  mainProduct: mainProduct,
                                  measurements:
                                      get<StockViewModel>()
                                          .availableMeasurement,
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 320,
                        child: ListView.builder(
                          itemCount:
                              watchOnly(
                                (StockViewModel x) => x.productsDetail,
                              )!.length,
                          itemBuilder: (context, index) {
                            var product =
                                watchOnly(
                                  (StockViewModel x) => x.productsDetail,
                                )![index];
                            return ProductDetailCard(
                              product: product,
                              key: ValueKey(index + 6000),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
    );
  }
}
