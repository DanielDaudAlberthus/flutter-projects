import 'package:flutter/material.dart';
import 'constants/app_theme.dart'; // Import tema
import 'screens/product_detail_screen.dart'; // Import layar detail produk

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Example', // Judul aplikasi
      theme: AppTheme.lightTheme, // Terapkan tema yang sudah dibuat
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      // Langsung tampilkan ProductDetailScreen sebagai halaman utama
      home: const ProductDetailScreen(),
      // Tidak perlu routes untuk contoh sederhana ini
    );
  }
}