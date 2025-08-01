import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

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

  // --- PERUBAHAN LOGIKA ---
  // 1. Hapus state 'isLocationConfirmed' karena tidak lagi dibutuhkan.
  // var isLocationConfirmed = false.obs;

  var selectedDateTime = Rxn<DateTime>();

  // Constants
  final double bakeryLat = -6.169552;
  final double bakeryLon = 106.564908;

  @override
  void onInit() {
    super.onInit();
    ever(distanceInKm, (_) => _updateShippingFee());
    ever(cartController.promoInfo, (_) => _updateShippingFee());

    // 2. Hapus listener pada addressC yang terlalu agresif.
    // addressC.addListener(() {
    //   isLocationConfirmed.value = false;
    // });

    _updateShippingFee();
  }

  void _updateShippingFee() {
    final promo = cartController.promoInfo.value;
    if (promo == null) {
      shippingFee.value = 0.0;
      return;
    }

    if (promo.isEligible) {
      shippingFee.value = 0.0;
    } else {
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
        distanceInKm.value = Geolocator.distanceBetween(bakeryLat, bakeryLon,
                userPosition!.latitude, userPosition!.longitude) /
            1000;

        List<Placemark> placemarks = await placemarkFromCoordinates(
            userPosition!.latitude, userPosition!.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          addressC.text =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.postalCode}";
        }

        // Tidak perlu lagi set flag 'isLocationConfirmed'
        Get.snackbar(
            'Sukses', 'Lokasi ditemukan dan ongkos kirim telah dihitung ulang.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12));
      } else if (status.isDenied) {
        Get.snackbar(
            'Error', 'Izin lokasi ditolak. Silakan isi alamat secara manual.');
      } else if (status.isPermanentlyDenied) {
        Get.snackbar('Error',
            'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengizinkan.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12));
        await openAppSettings();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan lokasi: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12));
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> pickOrderDateTime(BuildContext context) async {
    DateTime now = DateTime.now();
    // Tampilkan pemilih tanggal
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)), // Batas 30 hari ke depan
      locale: const Locale('id', 'ID'),
    );

    if (date != null) {
      // Tampilkan pemilih waktu
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime.value ?? now),
      );

      if (time != null) {
        // Gabungkan tanggal dan waktu yang dipilih
        selectedDateTime.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  Future<void> processCheckout() async {
    if (nameC.text.isEmpty || phoneC.text.isEmpty || addressC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Harap lengkapi semua data pengiriman.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final promo = cartController.promoInfo.value;
    if ((promo == null || !promo.isEligible) && distanceInKm.value <= 0) {
      Get.snackbar(
        'Perhatian',
        'Harap gunakan tombol "Gunakan Lokasi Saat Ini" untuk menghitung ongkos kirim terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      // --- PERUBAHAN DI SINI ---
      // Format tanggal menjadi YYYY-MM-DD jika ada
      final String? orderDate = selectedDateTime.value != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateTime.value!)
          : null;

      final response = await apiService.checkout(
        name: nameC.text,
        address: addressC.text,
        phone: phoneC.text,
        shippingFee: shippingFee.value,
        orderDate: orderDate, // Kirim tanggal yang sudah diformat
      );

      await Get.find<CartController>().fetchCartItems();
      Get.offNamed(Routes.PAYMENT, arguments: response.paymentToken);
      Get.snackbar(
        'Sukses',
        'Pesanan berhasil dibuat! Lanjutkan ke pembayaran.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
