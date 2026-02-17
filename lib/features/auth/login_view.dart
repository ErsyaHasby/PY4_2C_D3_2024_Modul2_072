// LoginView - Bertanggung jawab HANYA untuk UI/Tampilan
// Prinsip Single Responsibility: Tidak ada logic validasi di sini!

import 'package:flutter/material.dart';
// Import Controller milik sendiri (dari folder auth)
import 'package:logbook_app/features/auth/login_controller.dart';
// Import View dari fitur lain (Logbook) untuk navigasi
import 'package:logbook_app/features/logbook/counter_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Inisialisasi Otak (Controller untuk Logic)
  final LoginController _controller = LoginController();

  // Controller untuk mengambil input dari TextField
  // TextEditingController = Alat untuk mengontrol TextField
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // State untuk show/hide password
  bool _obscurePassword = true;

  // Fungsi untuk handle tombol Login
  void _handleLogin() {
    // Ambil nilai dari TextField
    String user = _userController.text;
    String pass = _passController.text;

    // Validasi input kosong
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Panggil fungsi login dari Controller (Logic terpisah!)
    bool isSuccess = _controller.login(user, pass);

    if (isSuccess) {
      // Login berhasil - Navigasi ke CounterView
      // pushReplacement = Ganti halaman (tidak bisa back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Passing data: kirim variabel 'user' ke parameter 'username'
          builder: (context) => CounterView(username: user),
        ),
      );
    } else {
      // Login gagal - Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Gagal! Gunakan admin/123"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Cleanup: Hapus controller saat widget di-dispose
  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Gatekeeper"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Icon Login
              const Icon(Icons.lock_person, size: 100, color: Colors.indigo),
              const SizedBox(height: 20),

              // Judul
              const Text(
                "Selamat Datang!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Silakan login untuk melanjutkan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // TextField Username
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Masukkan username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.indigo,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // TextField Password
              TextField(
                controller: _passController,
                obscureText: _obscurePassword, // Menyembunyikan teks password
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Masukkan password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.indigo,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Login
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Info kredensial
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.indigo),
                        SizedBox(width: 10),
                        Text(
                          "Kredensial Login:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Username: admin\nPassword: 123",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
