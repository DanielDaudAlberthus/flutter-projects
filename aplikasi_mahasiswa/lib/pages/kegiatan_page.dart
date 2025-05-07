import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Import untuk format tanggal dan waktu

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  List<Map<String, dynamic>> kegiatan = [];

  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadKegiatan();
  }

  Future<void> _loadKegiatan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('kegiatan');
    if (data != null) {
      try {
        final decoded = json.decode(data);
        if (decoded is List) {
          setState(() {
            kegiatan = List<Map<String, dynamic>>.from(decoded);
          });
        }
      } catch (e) {
        print("Gagal load kegiatan: $e");
      }
    }
  }

  Future<void> _saveKegiatan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kegiatan', json.encode(kegiatan));
    print("Disimpan: ${json.encode(kegiatan)}"); // Untuk debug
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format tanggal ke format YYYY-MM-DD
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Fungsi untuk menampilkan time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        // Format jam ke format HH:mm
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _jamController.text = '$hour:$minute';
      });
    }
  }

  void _tambahKegiatan() {
    // Reset tanggal dan jam yang dipilih
    _selectedDate = null;
    _selectedTime = null;
    _tanggalController.clear();
    _jamController.clear();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Tambah Kegiatan"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: "Nama Kegiatan"),
                ),
                TextField(
                  controller: _tanggalController,
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Tidak bisa diketik manual
                  onTap:
                      () => _selectDate(
                        context,
                      ), // Tampilkan date picker saat diklik
                ),
                TextField(
                  controller: _jamController,
                  decoration: InputDecoration(
                    labelText: "Jam",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true, // Tidak bisa diketik manual
                  onTap:
                      () => _selectTime(
                        context,
                      ), // Tampilkan time picker saat diklik
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _namaController.clear();
                  _tanggalController.clear();
                  _jamController.clear();
                  Navigator.pop(context);
                },
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_namaController.text.isNotEmpty &&
                      _tanggalController.text.isNotEmpty) {
                    setState(() {
                      kegiatan.add({
                        'nama': _namaController.text,
                        'tanggal': _tanggalController.text,
                        'jam':
                            _jamController.text.isNotEmpty
                                ? _jamController.text
                                : "-",
                        'selesai': false,
                      });
                      _saveKegiatan();
                    });
                    _namaController.clear();
                    _tanggalController.clear();
                    _jamController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text("Tambah"),
              ),
            ],
          ),
    );
  }

  void _hapusKegiatan(int index) {
    setState(() {
      kegiatan.removeAt(index);
      _saveKegiatan();
    });
  }

  void _updateSelesai(int index, bool value) {
    setState(() {
      kegiatan[index]['selesai'] = value;
      _saveKegiatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Kegiatan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKegiatan,
        tooltip: 'Tambah Kegiatan',
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child:
            kegiatan.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 20),
                      Text(
                        "Belum ada kegiatan",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tekan tombol + untuk menambah kegiatan baru",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: kegiatan.length,
                  itemBuilder: (context, index) {
                    final item = kegiatan[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Dismissible(
                        key: ValueKey(item['nama'] + item['tanggal']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _hapusKegiatan(index),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  item['selesai']
                                      ? Colors.green[100]
                                      : Colors.blue[100],
                              child: Icon(
                                item['selesai']
                                    ? Icons.check
                                    : Icons.pending_actions,
                                color:
                                    item['selesai']
                                        ? Colors.green
                                        : Colors.blue,
                              ),
                            ),
                            title: Text(
                              item['nama'],
                              style: TextStyle(
                                decoration:
                                    item['selesai']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color:
                                    item['selesai']
                                        ? Colors.grey
                                        : Colors.blueAccent,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      item['tanggal'],
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      item['jam'] ?? "-",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              value: item['selesai'],
                              onChanged: (val) => _updateSelesai(index, val!),
                              activeColor: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
