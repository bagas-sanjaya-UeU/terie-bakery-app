import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final ApiService apiService = Get.find();

  // Variabel reaktif untuk menyimpan data user dan status loading
  var user = Rxn<UserModel>(); // Dibuat nullable karena data diambil dari API
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  // Fungsi untuk mengambil data profil dari API
  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      user.value = await apiService.getProfile();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    // Hapus token dari penyimpanan lokal
    await apiService.logout();
    // Arahkan ke halaman login dan hapus semua halaman sebelumnya
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar('Sukses', 'Anda telah berhasil logout.');
  }
}
