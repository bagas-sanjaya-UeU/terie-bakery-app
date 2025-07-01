import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan controller dan langsung ambil 'arguments' (ID produk) dari GetX
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}
