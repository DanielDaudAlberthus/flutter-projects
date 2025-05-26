import 'package:flutter/material.dart';

class BasicGesturesPage extends StatefulWidget {
  const BasicGesturesPage({super.key});

  @override
  State<BasicGesturesPage> createState() => _BasicGesturesPageState();
}

class _BasicGesturesPageState extends State<BasicGesturesPage> {
  String _statusText = 'Lakukan gestur pada kotak di atas';

  void _updateStatus(String text) {
    setState(() {
      _statusText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _updateStatus('Tap Terdeteksi!'),
            onTapDown: (details) => _updateStatus('Tap Down: Jari menyentuh layar'),
            onTapUp: (details) => _updateStatus('Tap Up: Jari diangkat'),
            onTapCancel: () => _updateStatus('Tap Dibatalkan!'),
            onDoubleTap: () => _updateStatus('Double Tap Terdeteksi!'),
            onLongPress: () => _updateStatus('Long Press Terdeteksi!'),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Sentuh Aku!',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Status: $_statusText',
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}