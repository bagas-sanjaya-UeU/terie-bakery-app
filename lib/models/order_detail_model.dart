import 'ordered_product_model.dart'; // 1. Import model baru

class OrderDetailModel {
  final int id;
  final String orderNumber;
  final String? orderDate; // 2. Ganti tipe tanggal
  final String name;
  final String address;
  final String phone;
  final String status;
  final String subtotal; // Field baru
  final String shippingFee; // Field baru
  final String totalPrice;
  final String paymentStatus;
  final DateTime createdAt;
  final List<OrderedProductModel> products; // 2. Ganti tipe list

  OrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.orderDate, // 2. Ganti tipe tanggal
    required this.name,
    required this.address,
    required this.phone,
    required this.status,
    required this.subtotal,
    required this.shippingFee,
    required this.totalPrice,
    required this.paymentStatus,
    required this.createdAt,
    required this.products,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        // Tambahkan pengecekan null dengan nilai default untuk semua field
        id: json["id"] ?? 0,
        orderNumber: json["order_number"] ?? '',
        orderDate: json["order_date"] ?? '', // 2. Ganti tipe tanggal
        name: json["name"] ?? 'N/A',
        address: json["address"] ?? 'N/A',
        phone: json["phone"] ?? 'N/A',
        status: json["status"] ?? 'unknown',
        subtotal: json["subtotal"] ?? "0.00",
        shippingFee: json["shipping_fee"] ?? "0.00",
        totalPrice: json["total_price"] ?? "0.00",
        paymentStatus: json["payment_status"] ?? 'unpaid',
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        // 3. Gunakan OrderedProductModel untuk mem-parse daftar produk
        products: json["products"] == null
            ? []
            : List<OrderedProductModel>.from(
                json["products"].map((x) => OrderedProductModel.fromJson(x))),
      );
}
