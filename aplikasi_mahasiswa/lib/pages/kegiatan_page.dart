import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  List<Map<String, dynamic>> kegiatan = [];

  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();

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

  void _tambahKegiatan() {
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
                    labelText: "Tanggal (YYYY-MM-DD)",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _namaController.clear();
                  _tanggalController.clear();
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
                        'selesai': false,
                      });
                      _saveKegiatan();
                    });
                    _namaController.clear();
                    _tanggalController.clear();
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
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKegiatan,
        child: Icon(Icons.add),
        tooltip: 'Tambah Kegiatan',
      ),
      body:
          kegiatan.isEmpty
              ? Center(child: Text("Belum ada kegiatan."))
              : ListView.builder(
                itemCount: kegiatan.length,
                itemBuilder: (context, index) {
                  final item = kegiatan[index];
                  return Dismissible(
                    key: ValueKey(item['nama'] + item['tanggal']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _hapusKegiatan(index),
                    child: CheckboxListTile(
                      title: Text(
                        item['nama'],
                        style: TextStyle(
                          decoration:
                              item['selesai']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text('Tanggal: ${item['tanggal']}'),
                      value: item['selesai'],
                      onChanged: (val) => _updateSelesai(index, val!),
                    ),
                  );
                },
              ),
    );
  }
}
