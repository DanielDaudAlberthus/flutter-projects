import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureArenaPage extends StatefulWidget {
  const GestureArenaPage({super.key});

  @override
  State<GestureArenaPage> createState() => _GestureArenaPageState();
}

class _GestureArenaPageState extends State<GestureArenaPage> {
  String _winner = "Belum ada pemenang";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Drag Horizontal & Vertikal Bersaing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
              'Geser kotak ke samping atau ke atas/bawah.\nHanya satu gestur yang akan menang.',
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          // Gesture Arena
          RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              // Pesaing 1: Horizontal Drag
              HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  HorizontalDragGestureRecognizer>(
                    () => HorizontalDragGestureRecognizer(),
                    (HorizontalDragGestureRecognizer instance) {
                  // ===== BAGIAN YANG DIPERBAIKI =====
                  instance
                    ..onDown = (details) {
                      setState(() => _winner = 'Arena dimulai...');
                    }
                    ..onUpdate = (details) {
                      setState(() => _winner = 'Horizontal MENANG!');
                    };
                  // ===================================
                },
              ),
              // Pesaing 2: Vertical Drag
              VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                    (VerticalDragGestureRecognizer instance) {
                  // ===== BAGIAN YANG DIPERBAIKI =====
                  instance
                    ..onDown = (details) {
                      setState(() => _winner = 'Arena dimulai...');
                    }
                    ..onUpdate = (details) {
                      setState(() => _winner = 'Vertikal MENANG!');
                    };
                  // ===================================
                },
              ),
            },
            child: Container(
              width: 200,
              height: 200,
              color: Colors.redAccent,
              child: const Center(
                child: Text('Geser Aku!', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Pemenang Arena: $_winner',
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}