import 'dart:convert';

// Helper untuk mengubah list JSON menjadi List<ProductModel>
List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final String
      imageUrl; // Kita akan gunakan image_url yang sudah lengkap dari API

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"] ??
            'Deskripsi tidak tersedia', // Fallback jika deskripsi null
        price: json["price"], // API mengembalikan harga sebagai String
        quantity: json["quantity"],
        imageUrl: json["image_url"],
      );
}
