import 'package:flutter/material.dart';
import 'counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});
  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  // Fungsi untuk menampilkan dialog konfirmasi reset
  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Reset'),
          content: const Text(
            'Apakah Anda yakin ingin mereset counter ke 0? Data tidak dapat dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog tanpa reset
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                setState(() {
                  _controller.reset(); // Lakukan reset
                });
                // Tampilkan SnackBar konfirmasi
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Counter berhasil direset ke 0!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya, Reset'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mendapatkan warna berdasarkan tipe aktivitas
  Color _getHistoryColor(String type) {
    switch (type) {
      case 'add':
        return Colors.green.shade100;
      case 'subtract':
        return Colors.red.shade100;
      case 'reset':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // Fungsi untuk mendapatkan icon berdasarkan tipe aktivitas
  IconData _getHistoryIcon(String type) {
    switch (type) {
      case 'add':
        return Icons.add_circle;
      case 'subtract':
        return Icons.remove_circle;
      case 'reset':
        return Icons.refresh;
      default:
        return Icons.history;
    }
  }

  // Fungsi untuk mendapatkan warna icon berdasarkan tipe aktivitas
  Color _getIconColor(String type) {
    switch (type) {
      case 'add':
        return Colors.green;
      case 'subtract':
        return Colors.red;
      case 'reset':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TASK 2: History Logger Counter"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian Counter
            const Text("Total Hitungan:", style: TextStyle(fontSize: 20)),
            Text(
              '${_controller.value}',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),
            const Text("Atur Step:"),
            Slider(
              value: _controller.currentStep,
              min: 1,
              max: 10,
              divisions: 9,
              label: _controller.currentStep.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _controller.setCurrentStep(value);
                });
              },
            ),
            Text(
              'Step saat ini: ${_controller.step}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Tombol kontrol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Decrement
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _controller.decrement()),
                      icon: const Icon(Icons.remove, size: 18),
                      label: const Text('Kurang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tombol Reset
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton.icon(
                      onPressed:
                          _showResetConfirmation, // Panggil dialog konfirmasi
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tombol Increment
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _controller.increment()),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 2),

            // Bagian Riwayat
            const Text(
              "Riwayat Aktivitas (5 Terakhir):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Tampilkan riwayat menggunakan Expanded dan ListView
            Expanded(
              child: _controller.history.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada aktivitas',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _controller.history.length,
                      itemBuilder: (context, index) {
                        // Tampilkan dari yang terbaru (index terbalik)
                        final reversedIndex =
                            _controller.history.length - 1 - index;
                        final historyItem = _controller.history[reversedIndex];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          color: _getHistoryColor(historyItem.type),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getIconColor(historyItem.type),
                              child: Icon(
                                _getHistoryIcon(historyItem.type),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              historyItem.text,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getIconColor(historyItem.type),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
