class CheckoutResponseModel {
  final String orderNumber;
  final double totalPrice;
  final String paymentToken;

  CheckoutResponseModel({
    required this.orderNumber,
    required this.totalPrice,
    required this.paymentToken,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckoutResponseModel(
        orderNumber: json["order_number"],
        totalPrice: (json["total_price"] as num).toDouble(),
        paymentToken: json["payment_token"],
      );
}
