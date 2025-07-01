import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 158, 131, 122),
          centerTitle: true,
          title: const Text("Edit Profil",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          bottom: const TabBar(
            tabs: [
              Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  text: "Data Diri"),
              Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Ubah Password"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfileForm(),
            _buildPasswordForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Obx(() {
            final image = controller.imageFile.value;
            final initials = controller.initialUser.name.isNotEmpty
                ? controller.initialUser.name
                    .trim()
                    .split(' ')
                    .map((l) => l[0])
                    .take(2)
                    .join()
                : 'U';
            return Stack(
              children: [
                // Kalau image tidak ada, tampilkan inisial dalam CircleAvatar
                // kalau ada, tampilkan gambar profil user model network
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.brown.withOpacity(0.2),
                  backgroundImage: image != null
                      ? FileImage(image)
                      : controller.initialUser.imageUrl != null &&
                              controller.initialUser.imageUrl!.isNotEmpty
                          ? NetworkImage(controller.initialUser.imageUrl!)
                          : null,
                  child:
                      image == null && controller.initialUser.imageUrl == null
                          ? Text(
                              initials.toUpperCase(),
                              style: const TextStyle(fontSize: 40),
                            )
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton.filled(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: controller.pickImage,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          TextField(
              controller: controller.nameC,
              decoration: const InputDecoration(
                  labelText: "Nama Lengkap", border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(
              controller: controller.phoneC,
              decoration: const InputDecoration(
                  labelText: "Nomor Telepon", border: OutlineInputBorder()),
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          TextField(
              controller: controller.addressC,
              decoration: const InputDecoration(
                  labelText: "Alamat", border: OutlineInputBorder()),
              maxLines: 3),
          const SizedBox(height: 24),
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoadingProfile.value
                      ? null
                      : controller.saveProfile,
                  icon: controller.isLoadingProfile.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: const Text("Simpan Perubahan"),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("Gunakan password yang kuat dan mudah Anda ingat.",
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextField(
              controller: controller.currentPasswordC,
              decoration: const InputDecoration(
                  labelText: "Password Saat Ini", border: OutlineInputBorder()),
              obscureText: true),
          const SizedBox(height: 16),
          TextField(
              controller: controller.newPasswordC,
              decoration: const InputDecoration(
                  labelText: "Password Baru", border: OutlineInputBorder()),
              obscureText: true),
          const SizedBox(height: 16),
          TextField(
              controller: controller.confirmPasswordC,
              decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                  border: OutlineInputBorder()),
              obscureText: true),
          const SizedBox(height: 24),
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoadingPassword.value
                      ? null
                      : controller.savePassword,
                  icon: controller.isLoadingPassword.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.lock_reset),
                  label: const Text("Ubah Password"),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              )),
        ],
      ),
    );
  }
}
