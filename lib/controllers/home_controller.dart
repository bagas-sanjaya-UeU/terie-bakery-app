import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Variabel reaktif untuk daftar produk dan status loading
  var productList = <ProductModel>[].obs;
  var isLoading = true.obs;

  // onInit() adalah metode lifecycle GetX yang dipanggil saat controller dibuat.
  // Sempurna untuk mengambil data awal.
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true); // Mulai loading
      var products = await _apiService.getProducts();
      productList.assignAll(products); // Isi productList dengan data dari API
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false); // Selesai loading
    }
  }
}
