import 'cart_item_model.dart';
import 'promo_info_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final double subtotal;
  final PromoInfoModel?
      promoInfo; // 1. Buat properti ini menjadi nullable (bisa null)
  final int shippingCost;

  CartModel({
    required this.items,
    required this.subtotal,
    this.promoInfo, // 2. Jadikan opsional di constructor
    required this.shippingCost,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        items: List<CartItemModel>.from(
            json["items"].map((x) => CartItemModel.fromJson(x))),

        // Tambahkan fallback jika subtotal null
        subtotal: (json["subtotal"] as num? ?? 0).toDouble(),

        // 3. Cek jika key "promo_info" ada dan tidak null sebelum di-parse
        promoInfo: json["promo_info"] != null
            ? PromoInfoModel.fromJson(json["promo_info"])
            : null, // Jika tidak ada, nilainya akan null

        shippingCost: json["shipping_cost"] ?? 3000,
      );
}
