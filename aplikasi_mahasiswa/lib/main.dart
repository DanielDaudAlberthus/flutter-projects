import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'pages/kegiatan_page.dart';
import 'pages/jadwal_page.dart';
import 'pages/profil_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Mahasiswa',
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainPage(onThemeToggle: _toggleTheme),
    );
  }
}

class MainPage extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const MainPage({required this.onThemeToggle});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      KegiatanPage(),
      JadwalPage(),
      ProfilPage(onThemeToggle: widget.onThemeToggle),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.event), label: 'Kegiatan'),
        NavigationDestination(icon: Icon(Icons.schedule), label: 'Jadwal'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Akun'),
      ],
      body: (_) => _pages[_selectedIndex],
    );
  }
}
