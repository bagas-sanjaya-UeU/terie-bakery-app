import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../app/routes/app_pages.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  ResetPasswordPage({required this.email, super.key}); // Tambahkan super.key

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();

  // --- INI PERUBAHANNYA ---
  final ApiService _apiService = Get.find<ApiService>();
  // --------------------------

  bool _isPasswordObscured = true;
  bool _isLoading = false; // Tambahkan state loading untuk tombol

  void _resetPassword() async {
    if (_passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Password tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() {
      _isLoading = true; // Mulai loading
    });

    try {
      bool success = await _apiService.resetPassword(
          widget.email, _passwordController.text);
      if (success) {
        Get.snackbar('Success', 'Password berhasil diubah',
            backgroundColor: Colors.green, colorText: Colors.white);

        // Pastikan user benar-benar logout (hapus token) agar tidak ada auto-redirect dari Splash/Home
        await _apiService.logout();

        // Navigasi setelah frame saat ini untuk menghindari race condition dengan snackbar/rebuild
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != Routes.SPLASH) {
            Get.offAllNamed(Routes.SPLASH);
          }
        });
      } else {
        Get.snackbar('Error', 'Gagal mengubah password',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hentikan loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = const Color.fromARGB(255, 93, 64, 55);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: mainColor,
        elevation: 1,
        iconTheme:
            IconThemeData(color: Colors.white), // Membuat back button putih
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_open_rounded, size: 54, color: mainColor),
                  const SizedBox(height: 14),
                  const Text(
                    'Buat Password Baru',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Untuk akun:',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                        fontSize: 15,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 26),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      prefixIcon:
                          Icon(Icons.lock_outline_rounded, color: mainColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? Container()
                          : const Icon(Icons.check_rounded,
                              color: Colors.white),
                      label: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3),
                            )
                          : const Text(
                              'Ubah Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
