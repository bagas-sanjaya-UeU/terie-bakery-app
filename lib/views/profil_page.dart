import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({Key? key}) : super(key: key);

  // Daftarkan controller. GetX akan mengelolanya.
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6D4C41);
    final Color accentColor = const Color(0xFFFFC107);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profil Saya'),
        centerTitle: true,
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

        // Membuat inisial dari nama untuk avatar
        final initials = user.name.isNotEmpty
            ? user.name.trim().split(' ').map((l) => l[0]).take(2).join()
            : 'U';

        return RefreshIndicator(
          onRefresh: controller.fetchProfile,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Text(
                    initials,
                    style: TextStyle(
                        fontSize: 48,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
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
