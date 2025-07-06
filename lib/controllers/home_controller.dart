import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/banner_model.dart'; // Import model banner
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // State untuk produk
  var productList = <ProductModel>[].obs;
  var isLoading = true.obs;

  // State baru untuk banner
  var banners = Rxn<BannersResponseModel>();
  var areBannersLoading = true.obs;

  @override
  void onInit() {
    // Jalankan kedua fetch secara bersamaan untuk performa lebih baik
    Future.wait([
      fetchProducts(),
      fetchBanners(),
    ]);
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      var products = await _apiService.getProducts();
      productList.assignAll(products);
    } catch (e) {
      print('Error fetching products: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBanners() async {
    try {
      areBannersLoading(true);
      banners.value = await _apiService.getBanners();
    } catch (e) {
      print('Error fetching banners: ${e.toString()}');
    } finally {
      areBannersLoading(false);
    }
  }

  // Fungsi untuk me-refresh semua data di halaman beranda
  Future<void> refreshHomePage() async {
    await Future.wait([
      fetchProducts(),
      fetchBanners(),
    ]);
  }
}
