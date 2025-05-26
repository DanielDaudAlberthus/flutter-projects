import 'package:flutter/material.dart';

// Halaman Utama
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Jumlah angka sekarang:', style: TextStyle(fontSize: 18)),
          Text('$_counter', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _decrementCounter,
                child: Icon(Icons.remove),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}