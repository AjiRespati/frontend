import 'package:flutter/material.dart';

class ProductDetailDesktop extends StatelessWidget {
  const ProductDetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("TITLE")),
    );
  }
}
