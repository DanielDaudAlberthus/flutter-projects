# 📘 Dokumentasi Aplikasi Flutter: Navigasi 3 Halaman

Aplikasi ini dibuat dengan menggunakan Flutter dan Dart yang terdiri dari **3 halaman utama** dengan navigasi melalui BottomNavigationBar:

- **Halaman Utama**: Counter sederhana.
- **Halaman Hari Libur**: Menampilkan daftar Hari Libur Nasional dari API.
- **Halaman Profile**: Menampilkan informasi biodata pengguna.

---

## 🖥 Halaman Utama (Counter)

Halaman ini menampilkan angka yang bisa dinaikkan atau diturunkan melalui tombol tambah (+) dan kurang (-).

**Package yang digunakan:**
- Tidak ada tambahan package khusus di halaman ini (hanya bawaan Flutter).

**Kegunaan:**
- Belajar state management dasar menggunakan `setState()`.

**Source code:**
```dart
import 'package:flutter/material.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);
  void _decrementCounter() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Jumlah angka sekarang:', style: TextStyle(fontSize: 18)),
        Text('$_counter', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: _decrementCounter, child: const Icon(Icons.remove)),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: _incrementCounter, child: const Icon(Icons.add)),
        ])
      ]),
    );
  }
}
```

---

## 📅 Halaman Hari Libur Nasional (API)

Halaman ini mengambil data Hari Libur Nasional dari API publik secara realtime dan menampilkannya dalam bentuk tabel.

**Package yang digunakan:**
- **http (`http`)**: untuk melakukan HTTP GET request ke API.

**Kegunaan:**
- Belajar tentang pengambilan data dari REST API.
- Belajar parsing data JSON ke objek Dart.
- Belajar widget `DataTable` untuk menampilkan data secara rapi.

**Source code:**
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalamanHariLibur extends StatefulWidget {
  const HalamanHariLibur({super.key});

  @override
  _HalamanHariLiburState createState() => _HalamanHariLiburState();
}

class _HalamanHariLiburState extends State<HalamanHariLibur> {
  List hariLibur = [];
  bool loading = true;

  Future<void> fetchHariLibur() async {
    setState(() => loading = true);
    final response = await http.get(Uri.parse('https://api-harilibur.vercel.app/api'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      data.sort((a, b) => parseTanggal(a['holiday_date']).compareTo(parseTanggal(b['holiday_date'])));
      setState(() {
        hariLibur = data;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

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
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text('Daftar Hari Libur Nasional Indonesia (${DateTime.now().year})',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              DataTable(columns: const [
                DataColumn(label: Text('Tanggal')),
                DataColumn(label: Text('Keterangan')),
              ], rows: hariLibur.map((libur) {
                return DataRow(cells: [
                  DataCell(Text(libur['holiday_date'] ?? '')),
                  DataCell(Text(libur['holiday_name'] ?? '')),
                ]);
              }).toList())
            ]),
          );
  }
}
```

---

## 👤 Halaman Profile

Halaman ini menampilkan biodata pengguna termasuk nama, tempat tanggal lahir, alamat, dan foto profil dengan bentuk persegi panjang (rounded corner).

**Package yang digunakan:**
- Tidak ada tambahan package khusus di halaman ini (menggunakan widget bawaan Flutter).

**Kegunaan:**
- Belajar menggunakan gambar dari asset lokal.
- Belajar widget dasar untuk layout (Column, Padding, ClipRRect).

**Source code:**
```dart
import 'package:flutter/material.dart';

class HalamanProfile extends StatelessWidget {
  const HalamanProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 120,
              height: 160,
              child: Image.asset('assets/images/avatar.jpeg', fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Nama:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Adi Wahyu Pribadi', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        const Text('Tempat, Tanggal Lahir:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Jakarta, 24 Februari 1990', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        const Text('Alamat:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Jl. Sudirman No. 123, Jakarta', style: TextStyle(fontSize: 18)),
      ]),
    );
  }
}
```

---

## 📦 Penjelasan Dependensi Tambahan di `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.3.0
  cupertino_icons: ^1.0.8

flutter:
  uses-material-design: true
  assets:
    - assets/images/avatar.jpeg
```

| Package              | Keterangan                     |
|----------------------|--------------------------------|
| **http**             | Untuk mengambil data dari API dengan metode HTTP |
| **cupertino_icons**  | Menyediakan ikon tambahan (opsional) |
| **assets**           | Menyimpan gambar lokal aplikasi |

---

## 📌 Struktur Folder Project

```
lib/
├── main.dart
└── pages/
    ├── halaman_utama.dart
    ├── halaman_hari_libur.dart
    └── halaman_profile.dart
assets/
└── images/
    └── avatar.jpeg
```

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan kamu sudah menginstall dependensi terlebih dahulu:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

