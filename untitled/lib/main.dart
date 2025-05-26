import 'package:flutter/material.dart';

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