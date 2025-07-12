import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/banner_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // State untuk produk
  var productList = <ProductModel>[].obs;
  var isLoading = true.obs;

  // State untuk banner
  var banners = Rxn<BannersResponseModel>();
  var areBannersLoading = true.obs;

  // --- STATE BARU UNTUK PRODUK TERLARIS ---
  var bestsellerList = <ProductModel>[].obs;
  var areBestsellersLoading = true.obs;

  @override
  void onInit() {
    // Panggil semua fungsi fetch saat controller pertama kali dibuat
    refreshHomePage();
    super.onInit();
  }

  // --- FUNGSI BARU UNTUK FETCH BESTSELLERS ---
  Future<void> fetchBestsellers() async {
    try {
      areBestsellersLoading(true);
      var bestsellers = await _apiService.getBestsellers();
      bestsellerList.assignAll(bestsellers);
    } catch (e) {
      print('Error fetching bestsellers: ${e.toString()}');
    } finally {
      areBestsellersLoading(false);
    }
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

  // Fungsi refresh sekarang memanggil ketiga fungsi fetch
  Future<void> refreshHomePage() async {
    await Future.wait([
      fetchProducts(),
      fetchBanners(),
      fetchBestsellers(),
    ]);
  }
}
