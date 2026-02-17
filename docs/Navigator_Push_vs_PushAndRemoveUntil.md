# Perbedaan Navigator.push() vs Navigator.pushAndRemoveUntil()

## 📚 Konsep Dasar: Navigation Stack

Navigator di Flutter bekerja seperti **tumpukan piring** (Stack):
- Halaman paling atas = Halaman yang sedang dilihat user
- Tombol "Back" = Mengambil piring paling atas (pop)
- Push = Menambah piring baru di atas

```
┌─────────────────┐
│  Counter Page   │ ← User ada di sini (paling atas)
├─────────────────┤
│  Login Page     │
├─────────────────┤
│  Onboarding     │
└─────────────────┘
```

---

## 1️⃣ Navigator.push()

### Definisi:
**Menambahkan** halaman baru **DI ATAS** halaman sekarang.

### Karakteristik:
- ✅ Halaman lama **TETAP ADA** di stack
- ✅ User **BISA kembali** dengan tombol back
- ✅ Semua halaman sebelumnya **DISIMPAN**

### Syntax:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
);
```

### Visualisasi Stack:

**SEBELUM push:**
```
┌─────────────────┐
│   HomePage      │ ← User di sini
└─────────────────┘
```

**SETELAH push(DetailPage):**
```
┌─────────────────┐
│  DetailPage     │ ← User pindah ke sini
├─────────────────┤
│  HomePage       │ ← Masih ada di stack!
└─────────────────┘
```

**Tekan tombol Back:**
```
┌─────────────────┐
│  HomePage       │ ← Kembali ke sini
└─────────────────┘
```

### Kapan Digunakan?
✅ Halaman detail (dari list ke detail)
✅ Form input
✅ Preview / Info tambahan
✅ **User PERLU bisa kembali ke halaman sebelumnya**

### Contoh Kasus:
```dart
// Dari List Produk → Detail Produk
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetailPage(product: selectedProduct),
  ),
);
```

**Flow:**
```
List Produk → (push) → Detail Produk → (back) → List Produk ✅
```

---

## 2️⃣ Navigator.pushReplacement()

### Definisi:
**Mengganti** halaman sekarang dengan halaman baru.

### Karakteristik:
- ⚠️ Halaman lama **DIHAPUS** dari stack
- ❌ User **TIDAK bisa kembali** ke halaman sebelumnya
- ✅ Stack size berkurang

### Syntax:
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
);
```

### Visualisasi Stack:

**SEBELUM pushReplacement:**
```
┌─────────────────┐
│  LoginPage      │ ← User di sini
├─────────────────┤
│  OnboardingPage │
└─────────────────┘
```

**SETELAH pushReplacement(HomePage):**
```
┌─────────────────┐
│  HomePage       │ ← User pindah ke sini
├─────────────────┤
│  OnboardingPage │ ← LoginPage HILANG!
└─────────────────┘
```

**Coba tekan Back:**
```
┌─────────────────┐
│  OnboardingPage │ ← Kembali ke Onboarding (bukan Login!)
└─────────────────┘
```

### Kapan Digunakan?
✅ Login → Home (user tidak perlu kembali ke login)
✅ Onboarding → Login (sudah selesai onboarding)
✅ **User TIDAK BOLEH kembali ke halaman sebelumnya**

### Contoh Kasus:
```dart
// Setelah login sukses
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomePage()),
);
```

**Flow:**
```
Login → (pushReplacement) → Home → (back) → Keluar App ✅
(TIDAK kembali ke Login)
```

---

## 3️⃣ Navigator.pushAndRemoveUntil()

### Definisi:
**Menambahkan** halaman baru **DAN menghapus** halaman-halaman lama berdasarkan kondisi.

### Karakteristik:
- 🔥 **Paling powerful** untuk kontrol stack
- ✅ Bisa **hapus SEMUA halaman** sebelumnya
- ✅ Bisa **hapus BEBERAPA halaman** saja
- ✅ Bisa **reset stack** sepenuhnya

### Syntax:
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
  (route) => false,  // Hapus semua? true/false
);
```

### Parameter Kedua: `(route) => bool`
- **`(route) => false`** → Hapus **SEMUA** halaman
- **`(route) => true`** → **JANGAN** hapus (sama seperti push biasa)
- **Custom condition** → Hapus hingga kondisi tertentu

### Visualisasi Stack:

**SEBELUM pushAndRemoveUntil:**
```
┌─────────────────┐
│  CounterPage    │ ← User di sini (logout)
├─────────────────┤
│  LoginPage      │
├─────────────────┤
│  OnboardingPage │
└─────────────────┘
```

**SETELAH pushAndRemoveUntil(OnboardingPage, false):**
```
┌─────────────────┐
│  OnboardingPage │ ← User ke sini, SEMUA stack dihapus!
└─────────────────┘
```

**Coba tekan Back:**
```
App KELUAR (tidak ada halaman lagi!)
```

### Kapan Digunakan?
✅ **Logout** (hapus semua halaman, kembali ke onboarding)
✅ **Reset App** (kembali ke halaman pertama)
✅ **Deep link handling**
✅ **User HARUS mulai dari awal**

### Contoh Kasus 1: Logout (Hapus Semua)
```dart
// Logout: Kembali ke Onboarding, hapus semua stack
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => OnboardingPage()),
  (route) => false,  // false = hapus SEMUA
);
```

**Flow:**
```
Counter → (logout + pushAndRemoveUntil) → Onboarding
(Stack kosong, tidak bisa back!)
```

### Contoh Kasus 2: Hapus Hingga Homepage
```dart
// Hapus semua KECUALI HomePage
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => DetailPage()),
  ModalRoute.withName('/home'),  // Hapus hingga route bernama '/home'
);
```

---

## 🆚 Perbandingan Lengkap

| Aspek | push() | pushReplacement() | pushAndRemoveUntil() |
|-------|--------|-------------------|---------------------|
| **Halaman lama** | Tetap ada | Dihapus (1 halaman) | Dihapus (banyak/semua) |
| **Bisa Back** | ✅ Ya | ⚠️ Ke halaman sebelum yang diganti | ⚠️ Tergantung condition |
| **Stack size** | Bertambah | Tetap | Berkurang banyak |
| **Kompleksitas** | Mudah ⭐ | Mudah ⭐ | Sedang ⭐⭐ |
| **Use Case** | Detail, Form | Login, Onboarding | **Logout**, Reset |

---

## 📝 Jawaban Singkat untuk Pertanyaan

**Apa perbedaan mendasar antara Navigator.push() dan Navigator.pushAndRemoveUntil()?**

### Navigator.push()
- **Menambahkan** halaman baru di atas stack
- Halaman lama **TETAP ADA**
- User **bisa kembali** dengan tombol back
- Digunakan untuk navigasi normal (detail, form, dll)

### Navigator.pushAndRemoveUntil()
- **Menambahkan** halaman baru **DAN menghapus** halaman lama
- Bisa **hapus SEMUA** stack dengan `(route) => false`
- User **tidak bisa kembali** ke halaman yang dihapus
- Digunakan untuk **logout**, reset app, deep link

**Analogi:**
- `push()` = Menambah buku di atas tumpukan (tumpukan makin tinggi) 📚➕
- `pushAndRemoveUntil()` = Buang semua buku lama, mulai tumpukan baru 📚🗑️

---

## 💡 Best Practices

### Gunakan push() untuk:
```dart
// List → Detail
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage()));
```

### Gunakan pushReplacement() untuk:
```dart
// Onboarding → Login (tidak perlu kembali ke onboarding)
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
```

### Gunakan pushAndRemoveUntil() untuk:
```dart
// Logout: Hapus semua, kembali ke Onboarding
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => OnboardingPage()),
  (route) => false,
);
```

---

## 🎯 Contoh di Proyek LogBook App

### 1. Onboarding → Login
```dart
// Gunakan pushReplacement (tidak perlu kembali ke onboarding)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const LoginView()),
);
```

### 2. Login → Counter
```dart
// Gunakan pushReplacement (tidak perlu kembali ke login)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => CounterView(username: user)),
);
```

### 3. Logout dari Counter → Onboarding
```dart
// Gunakan pushAndRemoveUntil (hapus semua, mulai dari awal)
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const OnboardingView()),
  (route) => false,  // Hapus SEMUA stack
);
```

**Stack visualization:**

```
1. App Start:
   [Onboarding]

2. After pushReplacement(Login):
   [Login]  ← Onboarding HILANG

3. After pushReplacement(Counter):
   [Counter]  ← Login HILANG

4. After pushAndRemoveUntil(Onboarding, false):
   [Onboarding]  ← Counter HILANG, stack bersih!
```

---

## 🔑 Key Takeaways

1. **push()** = Tambah halaman, bisa back ✅
2. **pushReplacement()** = Ganti halaman, tidak bisa back ke yang diganti ⚠️
3. **pushAndRemoveUntil()** = Hapus banyak/semua halaman, kontrol penuh 🔥

**Security Note:**
Gunakan `pushAndRemoveUntil` untuk logout agar user tidak bisa tekan back untuk masuk lagi tanpa login!
