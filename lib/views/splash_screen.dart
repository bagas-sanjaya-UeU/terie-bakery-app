import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  // Daftarkan controller. Logika pengecekan token akan berjalan otomatis
  // saat controller diinisialisasi (di dalam onReady).
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/Logo_terie.png', // Ganti dengan path logo Anda
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Terie Bakery',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.brown),
          ],
        ),
      ),
    );
  }
}
