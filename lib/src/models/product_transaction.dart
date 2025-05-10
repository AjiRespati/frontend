class ProductTransaction {
  String productId;
  String? salesId;
  String? subAgentId;
  String? agentId;
  String? shopId;
  String? parentType;
  String? parentId;
  dynamic productDetail;
  int productAmount;
  double price;
  double totalPrice;
  String stockEvent;

  ProductTransaction({
    required this.productId,
    required this.salesId,
    required this.subAgentId,
    required this.agentId,
    required this.shopId,
    required this.parentType,
    required this.parentId,
    required this.productAmount,
    required this.productDetail,
    required this.price,
    required this.totalPrice,
    required this.stockEvent,
  });
}
