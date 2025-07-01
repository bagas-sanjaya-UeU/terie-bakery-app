import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../app/routes/app_pages.dart';
import '../models/user_model.dart'; // 1. Import UserModel

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 2. Panggil _apiService.login dan simpan hasilnya ke variabel UserModel
      final UserModel loggedInUser = await _apiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // 3. Jika kode sampai di sini, artinya login berhasil.
      //    Kita bisa langsung menggunakan data user.
      print("Login berhasil! Selamat datang, ${loggedInUser.name}");
      print("Email: ${loggedInUser.email}, Role: ${loggedInUser.role}");

      // Anda bisa menyimpan data user ini ke controller lain (misal AuthController) jika dibutuhkan di seluruh aplikasi
      // Contoh: Get.find<AuthController>().saveUser(loggedInUser);

      // 4. Langsung arahkan ke halaman home
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      // Tangkap dan tampilkan error dari ApiService
      Get.snackbar(
        'Login Gagal',
        e.toString(), // Pesan error sudah bersih dari ApiService
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Selalu sembunyikan loading di akhir
    }
  }
}
