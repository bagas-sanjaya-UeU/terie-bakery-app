import 'product_model.dart'; // Kita gunakan kembali ProductModel

class OrderDetailModel {
  final int id;
  final String orderNumber;
  final String name;
  final String address;
  final String phone;
  final String status;
  final String totalPrice;
  final String paymentStatus;
  final DateTime createdAt;
  final List<ProductModel> products;

  OrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.name,
    required this.address,
    required this.phone,
    required this.status,
    required this.totalPrice,
    required this.paymentStatus,
    required this.createdAt,
    required this.products,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        id: json["id"],
        orderNumber: json["order_number"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        status: json["status"],
        totalPrice: json["total_price"],
        paymentStatus: json["payment_status"],
        createdAt: DateTime.parse(json["created_at"]),
        products: List<ProductModel>.from(
            json["products"].map((x) => ProductModel.fromJson(x))),
      );
}
