import 'cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final double totalPrice;

  CartModel({
    required this.items,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        items: List<CartItemModel>.from(
            json["items"].map((x) => CartItemModel.fromJson(x))),
        // API mengembalikan total_price sebagai integer, kita konversi ke double
        totalPrice: (json["total_price"] as num).toDouble(),
      );
}
