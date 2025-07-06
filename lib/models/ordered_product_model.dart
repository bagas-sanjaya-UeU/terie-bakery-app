import 'product_model.dart';

// Model ini menggabungkan data produk dengan kuantitas yang dipesan
class OrderedProductModel {
  final ProductModel product;
  final int quantity; // Kuantitas untuk pesanan spesifik ini

  OrderedProductModel({
    required this.product,
    required this.quantity,
  });

  factory OrderedProductModel.fromJson(Map<String, dynamic> json) {
    return OrderedProductModel(
      // Buat objek ProductModel dari data produk utama
      product: ProductModel.fromJson(json),
      // Ambil kuantitas yang dipesan dari dalam objek 'pivot'
      quantity: json["pivot"]?["quantity"] ?? 0,
    );
  }
}
