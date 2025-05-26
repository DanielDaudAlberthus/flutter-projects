// lib/pages/scene_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class InteractiveScenePage extends StatefulWidget {
  final VoidCallback onQuestComplete;
  const InteractiveScenePage({super.key, required this.onQuestComplete});

  @override
  State<InteractiveScenePage> createState() => _InteractiveScenePageState();
}

class _InteractiveScenePageState extends State<InteractiveScenePage> {
  // === VARIABEL STATE ===
  // Posisi kunci yang bisa digeser
  Offset _keyPosition = const Offset(50, 400);
  // Status untuk menampilkan balon dialog astronaut
  bool _isDialogueVisible = false;
  // Status apakah peti sudah terbuka
  bool _isChestOpen = false;
  // Teks petunjuk yang muncul saat peti ditekan lama
  String _chestHint = "Terkunci...";
  // Offset untuk efek geser latar belakang (teleskop)
  Offset _backgroundOffset = Offset.zero;

  // GlobalKey digunakan untuk mendapatkan posisi & ukuran widget secara dinamis
  final GlobalKey _chestKey = GlobalKey();

  /// Fungsi untuk memeriksa apakah kunci dijatuhkan di atas peti
  void _checkForUnlock() {
    // Pastikan widget peti sudah ter-render di layar
    if (_chestKey.currentContext == null) return;

    // Dapatkan RenderBox dari peti untuk mengakses informasi ukuran dan posisi
    final RenderBox chestBox = _chestKey.currentContext!.findRenderObject() as RenderBox;
    // Dapatkan posisi global peti di layar
    final chestPosition = chestBox.localToGlobal(Offset.zero);
    // Buat sebuah Rect (persegi) yang merepresentasikan area peti
    final Rect chestRect = chestPosition & chestBox.size;

    // Periksa apakah posisi kunci saat ini berada di dalam area peti
    if (chestRect.contains(_keyPosition)) {
      setState(() {
        _isChestOpen = true;
        _chestHint = "Terbuka!";
        // Sembunyikan kunci dengan memindahkannya ke luar layar
        _keyPosition = const Offset(-200, -200);
      });
      // Pindah ke halaman akhir setelah 2 detik
      Future.delayed(const Duration(seconds: 2), widget.onQuestComplete);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // InteractiveViewer untuk mengaktifkan fungsionalitas Pinch-to-Zoom
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.5,
        maxScale: 3.0,
        child: Stack(
          children: [
            // === LATAR BELAKANG (DEMO GESTURE ARENA) ===
            Transform.translate(
              offset: _backgroundOffset,
              child: RawGestureDetector(
                // Mendaftarkan dua recognizer yang bersaing: Horizontal & Vertikal
                gestures: <Type, GestureRecognizerFactory>{
                  HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
                        () => HorizontalDragGestureRecognizer(), (instance) {
                    instance.onUpdate = (details) => setState(() => _backgroundOffset += Offset(details.delta.dx, 0));
                  },
                  ),
                  VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(), (instance) {
                    instance.onUpdate = (details) => setState(() => _backgroundOffset += Offset(0, details.delta.dy));
                  },
                  ),
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.5,
                  height: MediaQuery.of(context).size.height * 1.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://www.nasa.gov/wp-content/uploads/2023/11/iss069e005527-1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // === ASTRONAUT (GESTUR DOUBLE TAP) ===
            Positioned(
              bottom: 50,
              left: 60,
              child: GestureDetector(
                onDoubleTap: () => setState(() => _isDialogueVisible = !_isDialogueVisible),
                child: const Text("👩‍🚀", style: TextStyle(fontSize: 80)),
              ),
            ),

            // === BALON DIALOG ===
            if (_isDialogueVisible)
              Positioned(
                bottom: 140,
                left: 30,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Text("Aku harus buka peti itu!", style: TextStyle(color: Colors.black)),
                ),
              ),

            // === PETI (GESTUR LONG PRESS) ===
            Positioned(
              key: _chestKey,
              bottom: 50,
              right: 50,
              child: GestureDetector(
                onLongPress: () {
                  if (_isChestOpen) return;
                  setState(() => _chestHint = "Sepertinya butuh kunci...");
                  Future.delayed(const Duration(seconds: 2), () => setState(() => _chestHint = "Terkunci..."));
                },
                child: Text(_isChestOpen ? "🔓" : "📦", style: TextStyle(fontSize: 80)),
              ),
            ),
            Positioned(
              bottom: 140,
              right: 20,
              child: Text(_chestHint, style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
            ),

            // === KUNCI (GESTUR DRAG/PAN) ===
            Positioned(
              left: _keyPosition.dx,
              top: _keyPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (_isChestOpen) return;
                  setState(() => _keyPosition += details.delta);
                },
                onPanEnd: (details) {
                  if (_isChestOpen) return;
                  _checkForUnlock();
                },
                child: const Text("🔑", style: TextStyle(fontSize: 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}