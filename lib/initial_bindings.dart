import 'package:get/get.dart';

// Import service dan controller yang akan didaftarkan.
// Sesuaikan path import ini dengan struktur folder Anda.
import 'services/api_service.dart';
// Kita akan buat file ini nanti
import 'controllers/cart_controller.dart';
import 'controllers/profile_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Mendaftarkan ApiService agar bisa diakses dari mana saja.
    // lazyPut: Service baru akan dibuat saat pertama kali dibutuhkan.
    // fenix: true: Membuat service ini "abadi". Meskipun tidak digunakan sementara,
    //            ia tidak akan dihapus dari memori dan akan dibuat ulang saat dibutuhkan lagi.
    //            Sangat cocok untuk service API dan state global.
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);

    // Anda bisa menambahkan service atau controller global lainnya di sini.
    // Contoh: Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
