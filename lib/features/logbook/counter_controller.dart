// Model untuk menyimpan riwayat dengan tipe aksi
class HistoryItem {
  final String text;
  final String type; // 'add', 'subtract', 'reset'

  HistoryItem({required this.text, required this.type});
}

class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  int _step = 1;
  double _currentStep = 1.0; // State untuk slider
  List<HistoryItem> _history = []; // List untuk menyimpan riwayat aktivitas

  int get value => _counter; // Getter untuk akses data
  int get step => _step; // Getter untuk step
  double get currentStep => _currentStep; // Getter untuk current step slider
  List<HistoryItem> get history => _history; // Getter untuk riwayat

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
  }

  void increment() {
    _counter += _step;
    _addHistory('Menambah nilai sebesar $_step', 'add');
  }

  void decrement() {
    _counter -= _step;
    _addHistory('Mengurangi nilai sebesar $_step', 'subtract');
  }

  void reset() {
    _counter = 0;
    _addHistory('Reset counter ke 0', 'reset');
  }
}
