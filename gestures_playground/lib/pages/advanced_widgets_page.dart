// lib/pages/advanced_widgets_page.dart

import 'package:flutter/material.dart';

class AdvancedWidgetsPage extends StatefulWidget {
  const AdvancedWidgetsPage({super.key});

  @override
  State<AdvancedWidgetsPage> createState() => _AdvancedWidgetsPageState();
}

class _AdvancedWidgetsPageState extends State<AdvancedWidgetsPage> {
  String _pointerEvent = 'Tidak ada event';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 1. InkWell Demo
        _buildDemoCard(
          'InkWell Demo',
          'Ketuk kartu ini untuk melihat efek "splash" khas Material Design.',
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: const Text('Ketuk Aku', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),

        // 2. InteractiveViewer Demo
        _buildDemoCard(
          'InteractiveViewer Demo',
          'Cubit untuk zoom (pinch-to-zoom) dan geser logo di bawah ini.',
          SizedBox(
            width: double.infinity,
            height: 200,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20.0),
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                color: Colors.blueGrey[700],
                child: const FlutterLogo(size: 150),
              ),
            ),
          ),
        ),

        // 3. Listener Demo
        _buildDemoCard(
          'Listener (Event Mentah) Demo',
          'Menangkap event pointer mentah, bukan gestur. Lihat koordinatnya.',
          Column(
            children: [
              Listener(
                // ===== BAGIAN YANG DIPERBAIKI =====
                onPointerDown: (event) => setState(() => _pointerEvent =
                'Pointer Down\nPosisi: (X: ${event.position.dx.toStringAsFixed(1)}, Y: ${event.position.dy.toStringAsFixed(1)})'),
                onPointerMove: (event) => setState(() => _pointerEvent =
                'Pointer Move\nPosisi: (X: ${event.position.dx.toStringAsFixed(1)}, Y: ${event.position.dy.toStringAsFixed(1)})'),
                onPointerUp: (event) => setState(() =>
                _pointerEvent = 'Pointer Up\nEvent terakhir di (X: ${event.position.dx.toStringAsFixed(1)}, Y: ${event.position.dy.toStringAsFixed(1)})'),
                // ===================================
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.deepPurple[900],
                  child: Center(
                    child: Text(
                      _pointerEvent,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDemoCard(String title, String subtitle, Widget demoWidget) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            demoWidget,
          ],
        ),
      ),
    );
  }
}