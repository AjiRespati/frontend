class ProductTransaction {
  String productId;
  String? shopId;
  dynamic productDetail;
  int productAmount;
  double price;
  double totalPrice;
  String stockEvent;

  ProductTransaction({
    required this.productId,
    required this.shopId,
    required this.productAmount,
    required this.productDetail,
    required this.price,
    required this.totalPrice,
    required this.stockEvent,
  });
}
