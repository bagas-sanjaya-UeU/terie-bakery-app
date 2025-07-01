import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../controllers/cart_controller.dart'; // Import CartController untuk refresh keranjang

class ProductDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Terima productId yang dikirim melalui Get.arguments
  final int productId = Get.arguments as int;

  // State untuk data produk, kuantitas, dan status loading
  var product =
      Rxn<ProductModel>(); // Dibuat nullable (Rxn) karena data diambil dari API
  var quantity = 1.obs;
  var isLoading = true.obs;
  var isAddingToCart = false.obs;

  @override
  void onInit() {
    fetchProductDetail();
    super.onInit();
  }

  Future<void> fetchProductDetail() async {
    try {
      isLoading(true);
      product.value = await _apiService.getProductDetail(productId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void incrementQuantity() {
    if (product.value != null && quantity.value < product.value!.quantity) {
      quantity.value++;
    } else {
      Get.snackbar('Info', 'Stok produk tidak mencukupi.');
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Future<void> addToCart() async {
    if (product.value == null) return;

    try {
      isAddingToCart(true);
      await _apiService.addToCart(
        productId: product.value!.id,
        quantity: quantity.value,
      );

      // Panggil fungsi fetchCartItems dari CartController untuk refresh data
      Get.find<CartController>().fetchCartItems();

      Get.snackbar('Sukses',
          '${product.value!.name} berhasil ditambahkan ke keranjang.');
    } catch (e) {
      print("Error adding to cart: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isAddingToCart(false);
    }
  }
}
