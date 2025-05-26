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
      title: 'Flutter Drag Zoom Demo', // Judul aplikasi
      theme: ThemeData(
        // Tema dasar aplikasi.
        primarySwatch: Colors.indigo, // Warna tema
        useMaterial3: true, // Menggunakan Material Design 3
      ),
      // home menentukan widget yang akan ditampilkan sebagai layar utama.
      home: const DraggableZoomableWidget(), // Menggunakan widget Anda
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}


// --- Draggable Zoomable Widget (Kode Anda) ---
class DraggableZoomableWidget extends StatefulWidget {
  const DraggableZoomableWidget({super.key});

  @override
  State<DraggableZoomableWidget> createState() => _DraggableZoomableWidgetState();
}

class _DraggableZoomableWidgetState extends State<DraggableZoomableWidget> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  // Inisialisasi _offset agar kotak mulai di tengah layar
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero; // Titik fokus awal saat drag/scale dimulai
  Offset _sessionOffset = Offset.zero; // Offset saat sesi gesture dimulai

  @override
  void initState() {
    super.initState();
    // Menghitung offset awal agar di tengah setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Pastikan widget masih terpasang
        final Size screenSize = MediaQuery.of(context).size;
        final RenderBox? stackBox = context.findRenderObject() as RenderBox?;
        if (stackBox != null) {
          // Asumsikan ukuran container awal adalah 150x150
          const double initialWidth = 150.0;
          const double initialHeight = 150.0;
          setState(() {
            _offset = Offset(
                (screenSize.width - initialWidth) / 2,
                (screenSize.height - initialHeight - (AppBar().preferredSize.height + MediaQuery.of(context).padding.top)) / 2 // Kurangi tinggi AppBar & status bar
            );
            _sessionOffset = _offset; // Set juga session offset awal
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // AppBar diperlukan untuk mendapatkan tinggi yang benar saat menghitung posisi tengah
    final appBar = AppBar(
      title: const Text("Drag & Zoom"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );

    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        // --- Scale and Pan Handling (Combined for smoother interaction) ---
        onScaleStart: (details) {
          print("Scale Start: ${details.focalPoint}");
          _previousScale = _scale;
          _initialFocalPoint = details.focalPoint; // Simpan titik fokus awal
          _sessionOffset = _offset; // Simpan offset saat ini di awal gesture
        },
        onScaleUpdate: (details) {
          setState(() {
            // Hitung scale baru, batasi min/max
            final double newScale = (_previousScale * details.scale).clamp(0.5, 3.0);

            // Hitung offset baru berdasarkan scale dan pergerakan focal point
            // Rumus: offset_baru = titik_fokus - (titik_fokus_awal - offset_awal) * scale_baru / scale_awal
            // Ini memastikan zoom terjadi di sekitar titik fokus
            final Offset focalPointDelta = details.focalPoint - _initialFocalPoint;
            final Offset newOffset = _sessionOffset + focalPointDelta; // Offset jika hanya pan

            // Kombinasikan scaling dan panning
            // Offset akhir = (offset_awal + pergeseran_fokus) - (titik_fokus_awal - offset_awal) * (scale_baru / scale_awal - 1)
            // Atau cara yang lebih intuitif:
            // 1. Hitung posisi relatif titik fokus awal ke offset awal
            final Offset focalPointRelativeToInitialOffset = _initialFocalPoint - _sessionOffset;
            // 2. Hitung posisi baru titik fokus setelah scaling
            final Offset scaledFocalPointRelativeToInitialOffset = focalPointRelativeToInitialOffset * details.scale;
            // 3. Offset baru adalah titik fokus saat ini dikurangi posisi relatif yang sudah di-scale
            _offset = details.focalPoint - scaledFocalPointRelativeToInitialOffset;

            _scale = newScale; // Terapkan scale baru

            print("Scale Update: Scale = $_scale, Offset = $_offset, Focal Point: ${details.focalPoint}");
          });
        },
        onScaleEnd: (details) {
          print("Scale End");
          // Tidak perlu reset _previousScale di sini karena onScaleStart akan mengaturnya lagi
        },

        // Kita tidak perlu onPanUpdate terpisah jika sudah ditangani di onScaleUpdate
        // GestureDetector secara otomatis menangani 1 jari sebagai scale dengan scale=1.0
        // dan 2 jari sebagai scale sebenarnya.

        child: Container( // Gunakan Container full-screen agar GestureDetector mendeteksi di seluruh area
          color: Colors.grey[200], // Beri warna latar agar terlihat
          width: double.infinity,
          height: double.infinity,
          child: Stack( // Stack memungkinkan positioning absolut
            children: [
              Positioned(
                left: _offset.dx,
                top: _offset.dy,
                child: Transform.scale( // Terapkan skala
                  scale: _scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.black, width: 1.0 / _scale), // Sesuaikan lebar border saat zoom
                      borderRadius: BorderRadius.circular(8.0 / _scale), // Sesuaikan radius border
                      boxShadow: [ // Tambah shadow agar lebih menonjol
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2 / _scale,
                          blurRadius: 5 / _scale,
                          offset: Offset(2 / _scale, 3 / _scale),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Drag & Zoom Me',
                        style: TextStyle(color: Colors.white, fontSize: 16), // Ukuran font tetap
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}