// LoginController - Bertanggung jawab HANYA untuk logic validasi
// Prinsip Single Responsibility: Tidak ada UI code di sini!

class LoginController {
  // Database sederhana (Hardcoded) - Variabel Private
  // Underscore (_) menandakan enkapsulasi
  final String _validUsername = "admin";
  final String _validPassword = "123";

  // Fungsi pengecekan (Logic-Only)
  // Input: username dan password dari user
  // Output: true jika cocok, false jika salah
  bool login(String username, String password) {
    // Validasi: Cek apakah username DAN password cocok
    if (username == _validUsername && password == _validPassword) {
      return true; // Login berhasil
    }
    return false; // Login gagal
  }

  // ✅ Open-Closed Principle (OCP):
  // Struktur ini mudah dikembangkan tanpa mengubah fungsi login() di atas
  // Contoh pengembangan masa depan:

  // Future<bool> loginFromAPI(String username, String password) async {
  //   // Bisa tambah fungsi baru untuk validasi dari server/API
  //   // tanpa mengubah fungsi login() yang sudah ada
  // }

  // bool validateWithMultipleUsers(String username, String password) {
  //   Map<String, String> users = {
  //     'admin': '123',
  //     'user': 'user123',
  //     'guest': 'guest123',
  //   };
  //   return users[username] == password;
  // }
}
