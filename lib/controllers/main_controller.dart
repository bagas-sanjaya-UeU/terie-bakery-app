import 'package:get/get.dart';

class MainController extends GetxController {
  // Variabel reaktif untuk menyimpan index tab yang sedang aktif
  var tabIndex = 0.obs;

  // Fungsi untuk mengubah tab
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
