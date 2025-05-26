import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Halaman Hari Libur
class HalamanHariLibur extends StatefulWidget {
  const HalamanHariLibur({super.key});

  @override
  _HalamanHariLiburState createState() => _HalamanHariLiburState();
}

class _HalamanHariLiburState extends State<HalamanHariLibur> {
  List hariLibur = [];
  bool loading = true;

  Future<void> fetchHariLibur() async {
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse('https://api-harilibur.vercel.app/api'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      // Koreksi format tanggal sebelum sorting
      data.sort((a, b) {
        DateTime tanggalA = parseTanggal(a['holiday_date']);
        DateTime tanggalB = parseTanggal(b['holiday_date']);
        return tanggalA.compareTo(tanggalB);
      });

      setState(() {
        hariLibur = data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

// Fungsi tambahan untuk memperbaiki format tanggal
  DateTime parseTanggal(String tanggal) {
    final parts = tanggal.split('-');
    final tahun = parts[0];
    final bulan = parts[1].padLeft(2, '0');
    final hari = parts[2].padLeft(2, '0');
    return DateTime.parse('$tahun-$bulan-$hari');
  }


  @override
  void initState() {
    super.initState();
    fetchHariLibur();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Daftar Hari Libur Nasional Indonesia (${DateTime.now().year})',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          DataTable(
            columns: [
              DataColumn(label: Text('Tanggal')),
              // DataColumn(label: Text('Hari')),
              DataColumn(label: Text('Keterangan')),
            ],
            rows: hariLibur
                .map((libur) => DataRow(cells: [
              DataCell(Text(libur['holiday_date'] ?? '')),
              // DataCell(Text(libur['day_name'] ?? '')),
              DataCell(Text(libur['holiday_name'] ?? '')),
            ]))
                .toList(),
          ),
        ],
      ),
    );
  }
}