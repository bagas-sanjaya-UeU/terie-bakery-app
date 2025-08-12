import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import controller dan file routes
import '../controllers/login_controller.dart';
import '../app/routes/app_pages.dart';

// 1. Ubah menjadi StatelessWidget
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // 2. Dapatkan instance controller menggunakan Get.find()
  //    karena controller sudah di-inject melalui binding
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView untuk menghindari overflow
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/Koki.png', width: 150),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 90),
              decoration: const BoxDecoration(
                color: Color(0xFF5D4037),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Email', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 5),
                  TextField(
                    // 3. Hubungkan ke controller
                    controller: controller.emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Masukkan email anda',
                      hintStyle: const TextStyle(color: Colors.white54),
                      suffixIcon: const Icon(Icons.email, color: Colors.white),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Password', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 5),
                  // 4. Bungkus dengan Obx agar UI bisa update
                  Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Masukkan password anda',
                          hintStyle: const TextStyle(color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            // 5. Panggil method dari controller
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      // 6. Gunakan Get.toNamed untuk navigasi
                      onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                      child: const Text('Lupa Password?',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    // 7. Bungkus tombol dengan Obx untuk menampilkan loading
                    child: Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: controller.login,
                              child: const Text('MASUK',
                                  style: TextStyle(color: Colors.white)),
                            );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: const Text(
                        'Belum punya akun? Daftar disini',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
