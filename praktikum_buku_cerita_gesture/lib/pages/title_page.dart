// lib/pages/title_page.dart
import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget {
  // Callback untuk memberi tahu parent (main.dart) bahwa tombol start ditekan
  final VoidCallback onStartPressed;

  const TitlePage({super.key, required this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e272e),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🚀",
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 20),
            const Text(
              "Petualangan Antariksa",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Sebuah Cerita Interaktif",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            // Menggunakan Card dan InkWell untuk tombol yang lebih menarik
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: onStartPressed,
                splashColor: Colors.teal.withAlpha(50),
                borderRadius: BorderRadius.circular(15),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Text(
                    "Mulai Petualangan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}