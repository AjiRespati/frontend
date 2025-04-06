class ProductTransaction {
  String productId;
  dynamic productDetail;
  int productAmount;
  double price;
  double totalPrice;

  ProductTransaction({
    required this.productId,
    required this.productAmount,
    required this.productDetail,
    required this.price,
    required this.totalPrice,
  });
}
