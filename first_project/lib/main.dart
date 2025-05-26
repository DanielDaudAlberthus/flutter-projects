import 'package:flutter/material.dart';
import 'pages/halaman_utama.dart';
import 'pages/halaman_hari_libur.dart';
import 'pages/halaman_profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contoh Navigasi 3 Halaman',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    HalamanUtama(),
    HalamanHariLibur(),
    HalamanProfile(),
  ];

  final List<String> _titles = [
    'Halaman Utama',
    'Daftar Hari Libur Nasional',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]), // judul dinamis berdasarkan halaman aktif
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Utama'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Hari Libur'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}