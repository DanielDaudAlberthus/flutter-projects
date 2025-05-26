import 'package:flutter/material.dart';

class AppTheme {
  // Pilih warna dasar (seed color) untuk tema Anda
  static final Color _seedColor = Colors.teal; // Contoh: Ganti dengan warna lain

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true, // Pastikan Material 3 aktif
      brightness: Brightness.light,

      // Hasilkan skema warna dari seed color
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: Colors.grey[100],

      // Tema untuk Komponen Spesifik
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: _seedColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0), // Sesuaikan padding tombol
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          minimumSize: const Size(double.infinity, 50), // Sesuaikan tinggi tombol
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData( // Tambahkan tema untuk OutlinedButton
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: BorderSide(color: _seedColor, width: 1.5), // Border warna primer
            foregroundColor: _seedColor, // Teks warna primer
            minimumSize: const Size(double.infinity, 50),
          )
      ),

      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: _seedColor,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)
          )
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.grey[800],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        titleTextStyle: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),

      cardTheme: CardTheme(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)
      ),

      chipTheme: ChipThemeData(
        // --- Warna Latar ---
        backgroundColor: Colors.grey.shade200, // WARNA LATAR untuk chip TIDAK TERPILIH (abu terang)
        selectedColor: _seedColor,             // Warna latar untuk chip TERPILIH (warna tema)
        disabledColor: Colors.grey.shade300,   // Warna jika chip dinonaktifkan (opsional)

        // --- Warna Teks (Label) ---
        labelStyle: TextStyle(                  // Gaya teks saat chip TIDAK TERPILIH
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,              // << Warna teks gelap agar terbaca di background abu terang
        ),
        secondaryLabelStyle: TextStyle(          // Gaya teks saat chip TERPILIH
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,                 // << Warna teks putih agar kontras di background warna tema
        ),

        // --- Lainnya ---
        checkmarkColor: Colors.white,            // Warna ikon centang saat terpilih
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Jarak dalam chip
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Bentuk border chip
            // Border untuk chip tidak terpilih (mungkin tidak perlu jika background sudah beda)
            side: BorderSide(color: Colors.grey.shade300) // Border abu sangat tipis
        ),
        // elevation: 0, // Bisa atur shadow jika perlu
        // pressElevation: 2,
      ),

  );
}