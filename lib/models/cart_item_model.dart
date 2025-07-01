import 'product_model.dart'; // Kita gunakan kembali ProductModel yang sudah ada

class CartItemModel {
  final int id; // ID dari item di keranjang (bukan product_id)
  final int quantity;
  final ProductModel product; // Objek produk yang lengkap

  CartItemModel({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json["id"],
        quantity: json["quantity"],
        product: ProductModel.fromJson(
            json["product"]), // Ubah nested JSON menjadi objek ProductModel
      );
}
