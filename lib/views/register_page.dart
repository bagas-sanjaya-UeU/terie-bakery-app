import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF795548),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Registrasi',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 30),

              // Text Field Nama Lengkap
              _buildTextField(
                  controller: controller.nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person),
              const SizedBox(height: 20),

              // Text Field Email
              _buildTextField(
                  controller: controller.emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),

              // Text Field Password
              Obx(() => _buildPasswordField(
                    controller: controller.passwordController,
                    label: 'Password',
                    isObscure: controller.isPasswordHidden.value,
                    onToggle: controller.togglePasswordVisibility,
                  )),
              const SizedBox(height: 20),

              // Text Field Konfirmasi Password
              Obx(() => _buildPasswordField(
                    controller: controller.confirmPasswordController,
                    label: 'Konfirmasi Password',
                    isObscure: controller.isConfirmPasswordHidden.value,
                    onToggle: controller.toggleConfirmPasswordVisibility,
                  )),
              const SizedBox(height: 40),

              // Tombol Daftar
              Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade800,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed:
                      controller.isLoading.value ? null : controller.register,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('DAFTAR',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk text field biasa
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.brown.shade800),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.brown.shade800),
        labelText: label,
        labelStyle: TextStyle(color: Colors.brown.shade800),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // Helper widget untuk password field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: Colors.brown.shade800),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.brown.shade800),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.brown.shade800,
          ),
          onPressed: onToggle,
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.brown.shade800),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
