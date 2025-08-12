import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../app/routes/app_pages.dart';

class SplashController extends GetxController {
  final _storage = GetStorage();

  // onReady() adalah metode lifecycle GetX yang dipanggil setelah widget selesai di-render.
  // Ini adalah tempat yang aman untuk melakukan navigasi.
  @override
  void onReady() {
    super.onReady();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Beri sedikit jeda agar splash screen terlihat, ini bagus untuk UX
    await Future.delayed(const Duration(seconds: 3));

    // Jika saat ini bukan di Splash, jangan navigasi agar tidak menimpa halaman lain
    if (Get.currentRoute != Routes.SPLASH) {
      return;
    }

    // Baca token dari GetStorage
    final token = _storage.read('access_token');

    // Cek jika token ada dan tidak kosong
    if (token != null && token.isNotEmpty) {
      // Jika ada token, pengguna sudah login. Arahkan ke Beranda.
      // Get.offAllNamed akan menghapus semua halaman sebelumnya dari tumpukan.
  Get.offAllNamed(Routes.HOME);
    } else {
      // Jika tidak ada token, arahkan ke halaman Login.
  Get.offAllNamed(Routes.LOGIN);
    }
  }
}
