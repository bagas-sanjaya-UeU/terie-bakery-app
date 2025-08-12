import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../app/routes/app_pages.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  VerifyOtpPage({required this.email, super.key}); // Tambahkan super.key

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  // --- INI PERUBAHANNYA ---
  final ApiService _apiService = Get.find<ApiService>();
  // --------------------------

  bool _isLoading = false; // State untuk loading

  void _verifyOtp() async {
    if (_otpController.text.length != 4) {
      Get.snackbar('Error', 'OTP harus 4 digit',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() {
      _isLoading = true; // Mulai loading
    });

    try {
      bool success =
          await _apiService.verifyOtp(widget.email, _otpController.text);
      if (success) {
        // Hentikan navigasi jika widget sudah tidak ada di tree
        if (!mounted) return;
        Get.toNamed(Routes.RESET_PASSWORD, arguments: widget.email);
      } else {
        Get.snackbar('Error', 'OTP salah',
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
        title: const Text('Verifikasi OTP',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: mainColor,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_rounded, size: 52, color: mainColor),
                  const SizedBox(height: 14),
                  const Text(
                    'Verifikasi OTP',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Masukkan 4 digit kode OTP yang dikirim ke',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: TextStyle(
                        fontSize: 15,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        letterSpacing: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      counterText: '',
                      prefixIcon:
                          Icon(Icons.password_rounded, color: mainColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? Container()
                          : const Icon(Icons.verified_rounded,
                              color: Colors.white),
                      label: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3),
                            )
                          : const Text(
                              'Verifikasi OTP',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                      onPressed: _isLoading ? null : _verifyOtp,
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
