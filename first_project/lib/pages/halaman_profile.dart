import 'package:flutter/material.dart';

// Halaman Profile (menggantikan halaman dua)
class HalamanProfile extends StatelessWidget {
  const HalamanProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded corner
              child: SizedBox(
                width: 120,    // lebar 3
                height: 160,   // tinggi 4 (rasio 3:4)
                child: Image.asset(
                  'assets/images/avatar.jpeg', // Pastikan nama file sama persis
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Nama:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Didik Soecipto', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Tempat, Tanggal Lahir:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Jakarta, 24 Februari 1990', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Alamat:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Jl. Sudirman No. 123, Jakarta', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
