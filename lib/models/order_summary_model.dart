class OrderSummaryModel {
  final int id;
  final String orderNumber;
  final String status;
  final String totalPrice;
  final DateTime createdAt;

  OrderSummaryModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) =>
      OrderSummaryModel(
        id: json["id"],
        orderNumber: json["order_number"],
        status: json["status"],
        totalPrice: json["total_price"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
