// TASK 3: Import untuk data persistence
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Untuk JSON encode/decode

// Model untuk menyimpan riwayat dengan tipe aksi
class HistoryItem {
  final String text;
  final String type; // 'add', 'subtract', 'reset'

  HistoryItem({required this.text, required this.type});

  // TASK 3: Convert HistoryItem ke Map (untuk disimpan ke JSON)
  Map<String, dynamic> toJson() {
    return {'text': text, 'type': type};
  }

  // TASK 3: Create HistoryItem dari Map (saat load dari JSON)
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      text: json['text'] as String,
      type: json['type'] as String,
    );
  }
}

class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  int _step = 1;
  double _currentStep = 1.0; // State untuk slider
  List<HistoryItem> _history = []; // List untuk menyimpan riwayat aktivitas

  // TASK 3: Keys untuk SharedPreferences
  static const String _keyCounter = 'last_counter';
  static const String _keyHistory = 'history_list';

  int get value => _counter; // Getter untuk akses data
  int get step => _step; // Getter untuk step
  double get currentStep => _currentStep; // Getter untuk current step slider
  List<HistoryItem> get history => _history; // Getter untuk riwayat

  // TASK 3: Fungsi untuk menyimpan counter value
  // Dipanggil otomatis setiap kali counter berubah
  Future<void> saveLastValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCounter, _counter);
    print('💾 Counter saved: $_counter'); // Debug log
  }

  // TASK 3: Fungsi untuk load counter value
  // Dipanggil saat aplikasi pertama kali dibuka
  Future<void> loadLastValue() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt(_keyCounter) ?? 0; // Default: 0 jika belum ada
    print('📂 Counter loaded: $_counter'); // Debug log
  }

  // TASK 3: Fungsi untuk menyimpan history
  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert List<HistoryItem> ke List<String> (JSON)
    List<String> historyJson = _history.map((item) {
      return jsonEncode(item.toJson());
    }).toList();

    await prefs.setStringList(_keyHistory, historyJson);
    print('💾 History saved: ${_history.length} items'); // Debug log
  }

  // TASK 3: Fungsi untuk load history
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? historyJson = prefs.getStringList(_keyHistory);

    if (historyJson != null) {
      // Convert List<String> kembali ke List<HistoryItem>
      _history = historyJson.map((jsonString) {
        Map<String, dynamic> json = jsonDecode(jsonString);
        return HistoryItem.fromJson(json);
      }).toList();

      print('📂 History loaded: ${_history.length} items'); // Debug log
    } else {
      _history = []; // Jika belum ada data, list kosong
      print('📂 No history found, starting fresh'); // Debug log
    }
  }

  // TASK 3: Fungsi untuk load semua data sekaligus
  // Dipanggil saat CounterView pertama kali dibuka
  Future<void> loadAllData() async {
    await loadLastValue();
    await loadHistory();
  }

  // TASK 3: Fungsi untuk clear all data (untuk testing/reset)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCounter);
    await prefs.remove(_keyHistory);
    _counter = 0;
    _history = [];
    print('🗑️ All data cleared'); // Debug log
  }

  void setStep(int newStep) {
    if (newStep > 0) {
      _step = newStep;
    }
  }

  void setCurrentStep(double value) {
    _currentStep = value;
    setStep(value.toInt());
  }

  // Fungsi helper untuk menambah riwayat dengan timestamp
  void _addHistory(String activity, String type) {
    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    _history.add(HistoryItem(text: '$activity pada $time', type: type));

    // Batasi hanya 5 aktivitas terakhir
    if (_history.length > 5) {
      _history.removeAt(0); // Hapus aktivitas paling lama
    }

    // TASK 3: Auto-save history setiap kali ada perubahan
    saveHistory();
  }

  void increment() {
    _counter += _step;
    _addHistory('Menambah nilai sebesar $_step', 'add');
    // TASK 3: Auto-save counter setiap kali berubah
    saveLastValue();
  }

  void decrement() {
    _counter -= _step;
    _addHistory('Mengurangi nilai sebesar $_step', 'subtract');
    // TASK 3: Auto-save counter setiap kali berubah
    saveLastValue();
  }

  void reset() {
    _counter = 0;
    _addHistory('Reset counter ke 0', 'reset');
    // TASK 3: Auto-save counter setiap kali berubah
    saveLastValue();
  }
}
