import 'package:flutter/material.dart';

// --- Entry Point ---
// Fungsi main() adalah titik awal eksekusi aplikasi Flutter.
void main() {
  // runApp() memulai aplikasi Flutter dengan widget yang diberikan sebagai root.
  runApp(const MyApp());
}

// --- Root Widget ---
// MyApp adalah widget root aplikasi, biasanya StatelessWidget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Metode build() dari root widget mengembalikan widget utama aplikasi,
  // biasanya MaterialApp atau CupertinoApp.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Counter Demo', // Judul aplikasi (terlihat di task manager, dll.)
      theme: ThemeData(
        // Tema dasar aplikasi.
        primarySwatch: Colors.blue, // Warna utama
        useMaterial3: true, // Menggunakan Material Design 3
      ),
      // home menentukan widget yang akan ditampilkan sebagai layar utama.
      home: const CounterPage(title: 'Flutter Counter Home Page'), // Menggunakan CounterPage Anda
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}


// --- Counter Page Widget (Kode Anda) ---
class CounterPage extends StatefulWidget {
  // 1. StatefulWidget: Definisikan widget stateful
  const CounterPage({super.key, required this.title});
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // 2. State Object: Tempat menyimpan state
  int _counter = 0; // Variabel state internal

  @override
  void initState() {
    super.initState();
    // Contoh: Inisialisasi bisa dilakukan di sini
    print("CounterPage initState called!");
  }

  // 3. Metode untuk mengubah state
  void _incrementCounter() {
    // 4. Gunakan setState untuk memberi tahu Flutter ada perubahan
    setState(() {
      // Perubahan state terjadi di dalam callback setState
      _counter++;
      print("Counter incremented to: $_counter");
    });
  }

  @override
  Widget build(BuildContext context) {
    // 5. Build: Dipanggil saat state berubah (via setState)
    print("CounterPage build called!");
    return Scaffold(
      appBar: AppBar(
        // Menggunakan backgroundColor dari tema MaterialApp
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // Akses properti StatefulWidget via 'widget.'
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter', // Tampilkan state saat ini
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Panggil metode saat tombol ditekan
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    print("CounterPage dispose called!");
    // Contoh: Lakukan cleanup di sini jika ada controller atau listener
    super.dispose();
  }
}