import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({Key? key}) : super(key: key);

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6D4C41);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profil Saya',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              if (controller.user.value != null) {
                Get.toNamed(Routes.EDIT_PROFILE,
                    arguments: controller.user.value);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.brown));
        }
        if (controller.user.value == null) {
          return const Center(child: Text("Gagal memuat data profil."));
        }

        final user = controller.user.value!;

        final initials = user.name.isNotEmpty
            ? user.name
                .trim()
                .split(' ')
                .map((l) => l[0])
                .take(2)
                .join()
                .toUpperCase()
            : 'U';

        return RefreshIndicator(
          onRefresh: controller.fetchProfile,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // --- PERBAIKAN AVATAR DI SINI ---
                CircleAvatar(
                  radius: 70,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  // Gunakan backgroundImage. Jika null, Flutter akan otomatis menampilkan child.
                  backgroundImage:
                      user.imageUrl != null && user.imageUrl!.isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : null,
                  // Tampilkan inisial HANYA JIKA tidak ada gambar.
                  child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                      ? Text(
                          initials,
                          style: TextStyle(
                              fontSize: 48,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        )
                      : null, // Jangan tampilkan child jika ada backgroundImage
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                _buildProfileInfoCard(
                  'Informasi Akun',
                  [
                    _buildInfoRow(Icons.person_outline, 'Nama', user.name),
                    _buildInfoRow(Icons.email_outlined, 'Email', user.email),
                    _buildInfoRow(Icons.phone_outlined, 'Telepon',
                        user.phone ?? 'Belum diatur'),
                    _buildInfoRow(Icons.location_on_outlined, 'Alamat',
                        user.address ?? 'Belum diatur'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    onPressed: controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown.shade700, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
