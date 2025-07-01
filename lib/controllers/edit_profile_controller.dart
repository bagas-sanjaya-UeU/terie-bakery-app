import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final ApiService apiService = Get.find();
  // Terima data user awal dari halaman profil
  final UserModel initialUser = Get.arguments as UserModel;

  // Controllers untuk form
  late TextEditingController nameC, phoneC, addressC;
  late TextEditingController currentPasswordC, newPasswordC, confirmPasswordC;

  // State
  var isLoadingProfile = false.obs;
  var isLoadingPassword = false.obs;
  var imageFile = Rxn<File>(); // Untuk menyimpan file gambar yang dipilih

  @override
  void onInit() {
    super.onInit();
    // Isi form dengan data awal
    nameC = TextEditingController(text: initialUser.name);
    phoneC = TextEditingController(text: initialUser.phone);
    addressC = TextEditingController(text: initialUser.address);

    // Inisialisasi controller password
    currentPasswordC = TextEditingController();
    newPasswordC = TextEditingController();
    confirmPasswordC = TextEditingController();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    isLoadingProfile.value = true;
    try {
      await apiService.updateProfile(
        name: nameC.text,
        phone: phoneC.text,
        address: addressC.text,
        image: imageFile.value,
      );
      // Refresh data di halaman profil
      Get.find<ProfileController>().fetchProfile();
      Get.back(); // Kembali ke halaman profil
      Get.snackbar('Sukses', 'Profil berhasil diperbarui.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> savePassword() async {
    if (newPasswordC.text != confirmPasswordC.text) {
      Get.snackbar('Error', 'Password baru dan konfirmasi tidak cocok.');
      return;
    }
    if (newPasswordC.text.length < 6) {
      Get.snackbar('Error', 'Password baru minimal 6 karakter.');
      return;
    }

    isLoadingPassword.value = true;
    try {
      await apiService.updatePassword(
        currentPassword: currentPasswordC.text,
        newPassword: newPasswordC.text,
      );
      Get.back(); // Kembali ke halaman profil
      Get.snackbar('Sukses', 'Password berhasil diperbarui.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingPassword.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    phoneC.dispose();
    addressC.dispose();
    currentPasswordC.dispose();
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}
