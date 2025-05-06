import 'package:flutter/material.dart';

class JadwalPage extends StatefulWidget {
  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final List<Map<String, String>> _jadwal = [
    {
      "kode": "14564014",
      "matkul": "Pemrograman Berbasis Mobile",
      "sks": "3",
      "hari": "Senin",
      "jam": "08:00-10:30",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
    {
      "kode": "14569001",
      "matkul": "E-Business",
      "sks": "3",
      "hari": "Senin",
      "jam": "10:30-13:00",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
    {
      "kode": "14568001",
      "matkul": "Metodologi Penelitian",
      "sks": "3",
      "hari": "Selasa",
      "jam": "11:20-13:50",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
    {
      "kode": "14564015",
      "matkul": "Prak. Pemrograman Berbasis Mobile",
      "sks": "1",
      "hari": "Selasa",
      "jam": "13:50-16:20",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
    {
      "kode": "14565001",
      "matkul": "Manajemen Proyek",
      "sks": "3",
      "hari": "Rabu",
      "jam": "09:40-12:10",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
    {
      "kode": "14569005",
      "matkul": "Enterprise Software Engineering",
      "sks": "3",
      "hari": "Kamis",
      "jam": "10:30-13:00",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
    {
      "kode": "14567001",
      "matkul": "Geoinformatika",
      "sks": "2",
      "hari": "Jumat",
      "jam": "08:00-09:40",
      "ruang": "A",
      "kelas": "A",
      "dosen": "-",
    },
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredJadwal =
        _jadwal.where((item) {
          return item['matkul']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
        }).toList();

    int totalSKS = filteredJadwal.fold(
      0,
      (sum, item) => sum + int.parse(item['sks'] ?? '0'),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Mata Kuliah',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Table Header
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Kode MK")),
                DataColumn(label: Text("Matakuliah")),
                DataColumn(label: Text("SKS")),
                DataColumn(label: Text("Hari")),
                DataColumn(label: Text("Jam")),
                DataColumn(label: Text("Ruang")),
                DataColumn(label: Text("Kelas")),
                DataColumn(label: Text("Dosen")),
              ],
              rows: List.generate(filteredJadwal.length, (index) {
                final item = filteredJadwal[index];
                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(item['kode']!)),
                    DataCell(Text(item['matkul']!)),
                    DataCell(Text(item['sks']!)),
                    DataCell(Text(item['hari']!)),
                    DataCell(Text(item['jam']!)),
                    DataCell(Text(item['ruang']!)),
                    DataCell(Text(item['kelas']!)),
                    DataCell(Text(item['dosen']!)),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total SKS: $totalSKS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
