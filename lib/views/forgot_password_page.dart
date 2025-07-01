import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key})
      : super(key: key); // ✅ Tambahkan const jika ingin konsisten
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose(); // Pastikan untuk membersihkan controller
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Proses pengiriman email untuk reset password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email untuk reset password telah dikirim')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Kirim Email Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
