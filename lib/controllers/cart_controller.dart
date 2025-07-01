import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../services/api_service.dart';

class CartController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var cartItems = <CartItemModel>[].obs;
  var totalPrice = 0.0.obs;
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
      totalPrice.value = cart.totalPrice;
    } catch (e) {
      // Tidak menampilkan snackbar di sini agar tidak mengganggu jika dipanggil dari background
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
      Get.snackbar('Sukses', '${item.product.name} dihapus dari keranjang.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
