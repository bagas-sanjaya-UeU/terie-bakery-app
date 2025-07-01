import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/api_service.dart';
import 'cart_controller.dart';
import '../app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  final ApiService apiService = Get.find();
  final CartController cartController = Get.find();

  // Form Controllers
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();

  // State
  var isLoading = false.obs;
  var isFetchingLocation = false.obs;
  var distanceInKm = 0.0.obs;
  var shippingFee = 0.0.obs;
  Position? userPosition;

  // Constants
  final double bakeryLat = -6.169552;
  final double bakeryLon = 106.564908;
  // `costPerKm` sudah dihapus dari sini

  @override
  void onInit() {
    super.onInit();
    // Secara otomatis menghitung ongkir setiap kali jarak berubah
    ever(distanceInKm, (_) => _updateShippingFee());
    // Juga hitung ulang jika status promo berubah
    ever(cartController.promoInfo, (_) => _updateShippingFee());

    // Panggil sekali di awal untuk inisialisasi
    _updateShippingFee();
  }

  void _updateShippingFee() {
    final promo = cartController.promoInfo.value;
    if (promo == null) {
      shippingFee.value = 0.0;
      return;
    }

    // Jika pengguna berhak mendapatkan promo (gratis ongkir)
    if (promo.isEligible) {
      shippingFee.value = 0.0;
    } else {
      // Jika tidak, hitung ongkir menggunakan biaya per km dari API
      final costPerKmFromApi = cartController.shippingCost.value.toDouble();
      shippingFee.value = distanceInKm.value * costPerKmFromApi;
    }
  }

  Future<void> getCurrentLocation() async {
    isFetchingLocation.value = true;
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        userPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Menghitung jarak akan secara otomatis memicu _updateShippingFee()
        // karena ada listener `ever(distanceInKm, ...)` di onInit()
        distanceInKm.value = Geolocator.distanceBetween(bakeryLat, bakeryLon,
                userPosition!.latitude, userPosition!.longitude) /
            1000; // Konversi ke KM

        List<Placemark> placemarks = await placemarkFromCoordinates(
            userPosition!.latitude, userPosition!.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          addressC.text =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.postalCode}";
        }
      } else if (status.isDenied) {
        Get.snackbar(
            'Error', 'Izin lokasi ditolak. Silakan isi alamat secara manual.');
      } else if (status.isPermanentlyDenied) {
        Get.snackbar('Error',
            'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengizinkan.');
        await openAppSettings();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan lokasi: ${e.toString()}');
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> processCheckout() async {
    if (nameC.text.isEmpty || phoneC.text.isEmpty || addressC.text.isEmpty) {
      Get.snackbar('Error', 'Harap lengkapi semua data pengiriman.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiService.checkout(
        name: nameC.text,
        address: addressC.text,
        phone: phoneC.text,
        shippingFee: shippingFee.value,
      );

      await Get.find<CartController>().fetchCartItems();
      Get.offNamed(Routes.PAYMENT, arguments: response.paymentToken);
      Get.snackbar(
          'Sukses', 'Pesanan berhasil dibuat! Lanjutkan ke pembayaran.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    phoneC.dispose();
    addressC.dispose();
    super.onClose();
  }
}
