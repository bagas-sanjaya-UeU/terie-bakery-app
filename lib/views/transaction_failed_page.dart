import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';

class TransactionFailedPage extends StatelessWidget {
  const TransactionFailedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.highlight_off, color: Colors.red, size: 100),
              const SizedBox(height: 20),
              const Text(
                "Pembayaran Gagal",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Terjadi kesalahan saat memproses pembayaran Anda. Silakan coba lagi.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.HOME),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D4C41), // Warna coklat tema
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Kembali ke Beranda"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
