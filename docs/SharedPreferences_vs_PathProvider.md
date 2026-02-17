# Perbandingan: Shared Preferences vs Path Provider

## 📦 Shared Preferences

### Apa itu?
Library untuk menyimpan **data kecil** dalam bentuk **key-value pairs** (pasangan kunci-nilai).

### Kapan Digunakan?
✅ Menyimpan **preferensi user** (dark mode, bahasa, dll)
✅ Menyimpan **status sederhana** (sudah login, sudah onboarding)
✅ Cache data kecil (token, username)
✅ Settings aplikasi

### Tipe Data yang Didukung:
- `bool` - true/false
- `int` - angka bulat
- `double` - angka desimal
- `String` - teks
- `List<String>` - list string

### Contoh Kasus:
```dart
// Simpan: User sudah pernah lihat onboarding
await prefs.setBool('has_seen_onboarding', true);

// Simpan: Username yang terakhir login
await prefs.setString('last_username', 'admin');

// Simpan: Counter value
await prefs.setInt('counter', 42);
```

### Kelebihan:
- ✅ Mudah digunakan
- ✅ Data otomatis persisten (tidak hilang saat app ditutup)
- ✅ Cepat untuk data kecil

### Kekurangan:
- ❌ Tidak cocok untuk data besar
- ❌ Tidak ada enkripsi (jangan simpan password!)
- ❌ Hanya key-value, tidak bisa query kompleks

---

## 📂 Path Provider

### Apa itu?
Library untuk mendapatkan **lokasi folder** di device (seperti Documents, Cache, Temp).

### Kapan Digunakan?
✅ Menyimpan **file** (gambar, PDF, dokumen)
✅ Menyimpan **database** (SQLite)
✅ Menyimpan **logs**
✅ Download files

### Folder yang Bisa Diakses:
1. **Temporary Directory** - File sementara (bisa dihapus sistem)
2. **Application Documents Directory** - File permanen app
3. **Application Support Directory** - File internal app
4. **Downloads Directory** - Folder download (Android)
5. **External Storage** - SD Card (Android)

### Contoh Kasus:
```dart
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Dapatkan folder Documents
final directory = await getApplicationDocumentsDirectory();
final filePath = '${directory.path}/my_data.txt';

// Simpan file
final file = File(filePath);
await file.writeAsString('Hello World');

// Baca file
String content = await file.readAsString();
print(content); // Output: Hello World
```

### Kelebihan:
- ✅ Bisa simpan file ukuran besar
- ✅ Fleksibel (bisa simpan format apa saja)
- ✅ Bisa digunakan dengan database (SQLite)

### Kekurangan:
- ❌ Lebih kompleks
- ❌ Harus manage file sendiri (create, read, delete)

---

## 🆚 Perbandingan Langsung

| Aspek | Shared Preferences | Path Provider |
|-------|-------------------|---------------|
| **Tujuan** | Simpan data key-value | Akses lokasi folder |
| **Ukuran Data** | Kecil (KB) | Besar (MB/GB) |
| **Format** | Key-Value | File (apa saja) |
| **Kompleksitas** | Mudah ⭐ | Sedang ⭐⭐ |
| **Use Case** | Settings, preferences | File, database, gambar |
| **Persisten** | Ya (otomatis) | Ya (manual) |

---

## 🎯 Kapan Pakai yang Mana?

### Gunakan **Shared Preferences** jika:
- ✅ Data sederhana (settings, status)
- ✅ Tipe data: bool, int, String
- ✅ Ingin cara cepat & mudah

**Contoh:**
- Simpan: "Apakah user sudah login?"
- Simpan: "Tema dark mode atau light?"
- Simpan: "Bahasa yang dipilih"

### Gunakan **Path Provider** jika:
- ✅ Simpan file (gambar, PDF, video)
- ✅ Butuh database (SQLite + path_provider)
- ✅ Simpan data besar

**Contoh:**
- Simpan: Gambar yang di-download
- Simpan: Database SQLite
- Simpan: Log files

---

## 💡 Kombinasi Keduanya

Sering kali, kita pakai **KEDUA library** dalam satu project:

```dart
// Shared Preferences: Simpan path terakhir
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('last_image_path', '/path/to/image.jpg');

// Path Provider: Simpan file gambar
Directory dir = await getApplicationDocumentsDirectory();
File imageFile = File('${dir.path}/profile.jpg');
await imageFile.writeAsBytes(imageBytes);
```

---

## 📝 Kesimpulan

| Kebutuhan | Pilihan |
|-----------|---------|
| Username terakhir login | **Shared Preferences** |
| Token authentication | **Shared Preferences** |
| Sudah onboarding atau belum | **Shared Preferences** |
| Counter value | **Shared Preferences** |
| Gambar profile | **Path Provider** |
| Database SQLite | **Path Provider** |
| PDF yang di-download | **Path Provider** |
| Video offline | **Path Provider** |

**Rule of Thumb:**
- Data < 1MB + format sederhana → **Shared Preferences**
- Data > 1MB atau file → **Path Provider**
