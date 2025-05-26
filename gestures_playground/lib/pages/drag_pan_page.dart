import 'package:flutter/material.dart';

class DragPanPage extends StatefulWidget {
  const DragPanPage({super.key});

  @override
  State<DragPanPage> createState() => _DragPanPageState();
}

class _DragPanPageState extends State<DragPanPage> {
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _position += details.delta;
              });
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(child: Text('Geser Aku')),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gunakan onPanUpdate untuk menggeser objek.\nPosisi: (${_position.dx.toStringAsFixed(1)}, ${_position.dy.toStringAsFixed(1)})',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}