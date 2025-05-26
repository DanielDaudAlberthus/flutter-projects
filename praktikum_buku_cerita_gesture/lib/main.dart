// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/scene_page.dart';
import 'pages/title_page.dart';
import 'pages/end_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Storybook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Nunito', // Font yang lebih soft untuk cerita
      ),
      home: StorybookHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Widget utama yang memegang PageView untuk navigasi cerita
class StorybookHome extends StatelessWidget {
  StorybookHome({super.key});

  // Controller untuk mengontrol halaman pada PageView secara programatik
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        // Menonaktifkan scroll manual agar navigasi hanya bisa melalui tombol
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Halaman 1: Judul
          TitlePage(onStartPressed: () {
            _controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }),

          // Halaman 2: Adegan Interaktif Utama
          InteractiveScenePage(onQuestComplete: () {
            _controller.animateToPage(
              2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }),

          // Halaman 3: Penutup
          EndPage(onRestart: () {
            _controller.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }),
        ],
      ),
    );
  }
}