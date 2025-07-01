import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import controller dan halaman-halaman lainnya
import '../controllers/main_controller.dart';
import 'beranda_page.dart';
import 'keranjang_page.dart';
import 'profil_page.dart';
import 'riwayat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // Daftarkan MainController
  final MainController controller = Get.put(MainController());

  // Daftar halaman untuk Bottom Navigation
  final List<Widget> pages = [
    BerandaPage(), // Halaman Beranda yang baru
    RiwayatPage(),
    KeranjangPage(), // Nanti kita akan refactor ini juga
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan Obx untuk mendengarkan perubahan pada tabIndex
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            backgroundColor: const Color(0xFF6D4C41),
            selectedItemColor: const Color(0xFFFFC107),
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex, // Panggil fungsi dari controller
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Riwayat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
            ],
          )),
    );
  }
}
