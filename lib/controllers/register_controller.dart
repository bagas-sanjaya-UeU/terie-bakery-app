import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../app/routes/app_pages.dart';
import '../models/user_model.dart';

class RegisterController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Controllers untuk setiap text field
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Variabel reaktif untuk UI
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> register() async {
    // Validasi input
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi.');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Password dan konfirmasi password tidak cocok.');
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter.');
      return;
    }

    try {
      isLoading.value = true;
      final UserModel newUser = await _apiService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Jika berhasil, langsung arahkan ke home
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
          'Sukses', 'Registrasi berhasil! Selamat datang, ${newUser.name}.');
    } catch (e) {
      Get.snackbar(
        'Registrasi Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
