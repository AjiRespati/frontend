import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/src/widgets/page_container.dart';

class Suppliers extends StatefulWidget {
  const Suppliers({super.key});

  @override
  State<Suppliers> createState() => _SuppliersState();
}

class _SuppliersState extends State<Suppliers> {
  final ApiService apiService = ApiService();
  List<dynamic> suppliers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  void _fetchSuppliers() async {
    List<dynamic> data = await apiService.fetchSuppliers();
    setState(() {
      suppliers = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: isLoading
            ? const Center(child: CircularProgressIndicator())
            : suppliers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        const Center(
                          child: Text("No suppliers found"),
                        ),
                        GradientElevatedButton(
                          buttonHeight: 33,
                          onPressed: () {
                            Navigator.pushNamed(context, addSuppliersRoute);
                          },
                          child: Text(
                            "Add Supplier",
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
                              "Suppliers",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                            GradientElevatedButton(
                              buttonHeight: 33,
                              onPressed: () {
                                Navigator.pushNamed(context, addSuppliersRoute);
                              },
                              child: Text(
                                "Add Supplier",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
                            itemCount: suppliers.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.amber,
                                width: 30,
                                height: 30,
                              );
                              // return ProductCard(product: products[index]);
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
