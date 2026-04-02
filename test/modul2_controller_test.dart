// UNIT TEST MODUL 2: AUTHENTICATION (LoginController)
// File: test/modul2_controller_test.dart
// Jalankan dengan: flutter test test/modul2_controller_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../lib/features/auth/login_controller.dart';

void main() {
  // ============================================================
  // TEST SUITE: AUTHENTICATION - LoginController
  // ============================================================
  group('Authentication - LoginController Tests', () {
    late LoginController loginController;

    setUp(() {
      loginController = LoginController();
    });

    // TC-AUTH-01: Valid login admin
    test(
      'TC-AUTH-01: Positif - Login admin dengan password benar (admin, 123)',
      () {
        bool result = loginController.login('admin', '123');
        expect(result, true);
        print('✓ TC-AUTH-01 PASS: Admin login berhasil');
      },
    );

    // TC-AUTH-02: Valid login user
    test(
      'TC-AUTH-02: Positif - Login user dengan password benar (user, user123)',
      () {
        bool result = loginController.login('user', 'user123');
        expect(result, true);
        print('✓ TC-AUTH-02 PASS: User login berhasil');
      },
    );

    // TC-AUTH-03: Valid login guest
    test(
      'TC-AUTH-03: Positif - Login guest dengan password benar (guest, guest)',
      () {
        bool result = loginController.login('guest', 'guest');
        expect(result, true);
        print('✓ TC-AUTH-03 PASS: Guest login berhasil');
      },
    );

    // TC-AUTH-04: Valid login dosen
    test(
      'TC-AUTH-04: Positif - Login dosen dengan password benar (dosen, polban2024)',
      () {
        bool result = loginController.login('dosen', 'polban2024');
        expect(result, true);
        print('✓ TC-AUTH-04 PASS: Dosen login berhasil');
      },
    );

    // TC-AUTH-05: Invalid login - password salah
    test(
      'TC-AUTH-05: Negatif - Login admin dengan password SALAH (admin, wrongpass)',
      () {
        bool result = loginController.login('admin', 'wrongpass');
        expect(result, false);
        print('✗ TC-AUTH-05 PASS: Login gagal karena password salah');
      },
    );

    // TC-AUTH-06: Invalid login - username tidak ada
    test(
      'TC-AUTH-06: Negatif - Login dengan username TIDAK ADA (hacker, anypass)',
      () {
        bool result = loginController.login('hacker', 'anypass');
        expect(result, false);
        print('✗ TC-AUTH-06 PASS: Login gagal karena username tidak terdaftar');
      },
    );

    // TC-AUTH-07: Invalid login - username kosong
    test(
      'TC-AUTH-07: Negatif - Login dengan username KOSONG ("", password)',
      () {
        bool result = loginController.login('', 'password');
        expect(result, false);
        print('✗ TC-AUTH-07 PASS: Login gagal karena username kosong');
      },
    );

    // TC-AUTH-08: Check username exist - true
    test(
      'TC-AUTH-08: Positif - Check username exist TRUE (isUsernameExist("admin"))',
      () {
        bool result = loginController.isUsernameExist('admin');
        expect(result, true);
        print('✓ TC-AUTH-08 PASS: Username admin terdeteksi ada');
      },
    );

    // TC-AUTH-09: Check username exist - false
    test(
      'TC-AUTH-09: Positif - Check username exist FALSE (isUsernameExist("hacker"))',
      () {
        bool result = loginController.isUsernameExist('hacker');
        expect(result, false);
        print('✓ TC-AUTH-09 PASS: Username hacker terdeteksi tidak ada');
      },
    );

    // TC-AUTH-10: Get available users
    test(
      'TC-AUTH-10: Positif - Get available users list (getAvailableUsers())',
      () {
        List<String> users = loginController.getAvailableUsers();
        expect(users.length, 4);
        expect(users, containsAll(['admin', 'user', 'guest', 'dosen']));
        print(
          '✓ TC-AUTH-10 PASS: List users ada 4 akun: admin, user, guest, dosen',
        );
      },
    );
  });
}
