import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../models/promo_info_model.dart'; // Import model promo yang baru

class CartController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var cartItems = <CartItemModel>[].obs;
  var subtotal = 0.0.obs; // Ganti nama dari totalPrice
  var promoInfo =
      Rxn<PromoInfoModel>(); // State baru untuk menyimpan info promo
  var shippingCost = 0.obs; // State baru untuk menyimpan biaya per km
  var isLoading = true.obs;

  // Dipanggil saat controller pertama kali dibuat oleh InitialBinding
  @override
  void onInit() {
    fetchCartItems();
    super.onInit();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading(true);
      final cart = await _apiService.getCart();
      cartItems.assignAll(cart.items);
      subtotal.value = cart.subtotal;
      promoInfo.value = cart.promoInfo;
      shippingCost.value = cart.shippingCost; // Simpan biaya per km dari API
    } catch (e) {
      print("Error fetching cart: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateQuantity(CartItemModel item, int newQuantity) async {
    if (newQuantity < 1) {
      deleteItem(item); // Jika kuantitas 0, hapus item
      return;
    }
    try {
      await _apiService.updateCartItemQuantity(
          cartItemId: item.id, quantity: newQuantity);
      // Refresh seluruh keranjang untuk memastikan data konsisten
      await fetchCartItems();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteItem(CartItemModel item) async {
    try {
      await _apiService.deleteCartItem(cartItemId: item.id);
      // Hapus item dari list lokal agar UI update seketika
      cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      // Refresh untuk mendapatkan total harga terbaru
      await fetchCartItems();
      Get.snackbar('Sukses', '${item.product.name} dihapus dari keranjang.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addToCart(ProductModel product) async {
    try {
      // Panggil ApiService untuk menambahkan item (kuantitas 1)
      await _apiService.addToCart(productId: product.id, quantity: 1);

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Sukses',
        '${product.name} ditambahkan ke keranjang.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );

      // Refresh data keranjang setelah berhasil menambahkan
      fetchCartItems();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan produk: ${e.toString()}');
    }
  }
}
