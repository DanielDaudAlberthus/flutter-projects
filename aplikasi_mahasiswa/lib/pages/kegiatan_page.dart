import 'package:flutter/material.dart';

class KegiatanPage extends StatefulWidget {
  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  final List<Map<String, dynamic>> kegiatan = [
    {'nama': 'Seminar Teknologi', 'tanggal': '2025-05-10', 'selesai': false},
    {'nama': 'Lomba UI/UX', 'tanggal': '2025-05-12', 'selesai': false},
    {'nama': 'Workshop Flutter', 'tanggal': '2025-05-15', 'selesai': false},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kegiatan.length,
      itemBuilder: (context, index) {
        final item = kegiatan[index];
        return CheckboxListTile(
          title: Text(item['nama']),
          subtitle: Text('Tanggal: ${item['tanggal']}'),
          value: item['selesai'],
          onChanged: (val) {
            setState(() {
              kegiatan[index]['selesai'] = val!;
            });
          },
        );
      },
    );
  }
}
