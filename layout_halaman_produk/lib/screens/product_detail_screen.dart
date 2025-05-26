import 'package:flutter/material.dart';
// import 'dart:math'; // Tidak lagi diperlukan jika tidak ada warna acak

// Pastikan import ini jika Anda memisahkan AppTheme
// import '../constants/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  // --- Helper Widget untuk Konten ---

  // 1. Widget untuk Gambar Produk (Diperbarui)
  Widget _buildProductImage() {
    // AspectRatio menjaga rasio gambar
    return AspectRatio(
      aspectRatio: 16 / 10, // Sesuaikan rasio sesuai gambar Anda
      // Container bisa tetap ada untuk memberi background atau dekorasi lain jika perlu
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Warna background saat gambar loading/error
          // Jika Anda menggunakan ClipRRect di luar, Container ini mungkin tidak perlu BorderRadius
          // borderRadius: BorderRadius.circular(16.0), // Contoh jika ingin rounded di sini
        ),
        // Menggunakan Image.asset untuk memuat gambar dari folder assets
        child: Image.asset(
          'images/running_shoes.png', // <-- Path sesuai deklarasi di pubspec.yaml
          fit: BoxFit.cover, // <-- Penting: Mengatur bagaimana gambar mengisi ruang
          // BoxFit.cover: Penuhi area, potong jika perlu agar rasio pas.
          // BoxFit.contain: Tampilkan seluruh gambar, mungkin ada ruang kosong.
          // BoxFit.fill: Penuhi area, distorsi rasio gambar.
          // dll.
          semanticLabel: 'Sepatu Lari', // Deskripsi untuk aksesibilitas
        ),
      ),
    );
  }

  // 2. Widget untuk Rating Bintang (Sama seperti sebelumnya)
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: 18));
    }
    if (halfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: 18));
    }
    for (int i = (fullStars + (halfStar ? 1 : 0)); i < 5; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: 18));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  // 3. Widget untuk Pilihan (Warna/Ukuran) (Sama seperti sebelumnya)
  Widget _buildOptionsSelector(BuildContext context, String label, List<Widget> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 6.0,
          children: options,
        ),
      ],
    );
  }

  // Contoh Pilihan Warna (Lingkaran) (Sama seperti sebelumnya)
  List<Widget> _buildColorOptions(BuildContext context) {
    List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.black, Colors.yellow, Colors.purple];
    Color selectedColor = colors[1]; // Dummy state

    return List.generate(colors.length, (index) {
      bool isSelected = colors[index] == selectedColor;
      return GestureDetector(
        onTap: () { /* Logika pilih warna */ },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colors[index],
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              width: isSelected ? 3.0 : 1.5,
            ),
          ),
          child: isSelected
              ? const Center(child: Icon(Icons.check, color: Colors.white, size: 18))
              : null,
        ),
      );
    });
  }

  // Contoh Pilihan Ukuran (Chip) (Sama seperti sebelumnya)
  List<Widget> _buildSizeOptions(BuildContext context) {
    List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    String selectedSize = sizes[1]; // Dummy state

    return List.generate(sizes.length, (index) {
      return ChoiceChip(
        label: Text(sizes[index]),
        selected: selectedSize == sizes[index],
        onSelected: (selected) { /* Logika pilih ukuran */ },
      );
    });
  }

  // 4. Widget untuk Informasi Teks Produk (Sama seperti sebelumnya)
  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sepatu Lari Super Cepat ZoomX 2025 Edition',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildRatingStars(4.7),
                  const SizedBox(width: 8.0),
                  Text('(4.7)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(' | 152 Ulasan', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                ],
              ),
              Text(
                'Rp 1.299.000',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          _buildOptionsSelector(context, 'Warna Tersedia', _buildColorOptions(context)),
          const SizedBox(height: 20.0),
          _buildOptionsSelector(context, 'Ukuran Tersedia (EU)', _buildSizeOptions(context)),
          const SizedBox(height: 24.0),
          Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Text(
            'Rasakan kecepatan tanpa batas dengan Sepatu Lari Super Cepat ZoomX 2025. Didesain dengan teknologi bantalan terbaru untuk responsivitas maksimal dan upper mesh yang ringan untuk sirkulasi udara optimal. Cocok untuk pelari jarak jauh maupun pendek yang mencari performa terbaik.\n\nFitur Utama:\n• Teknologi ZoomX Foam\n• Upper FlyMesh terbaru\n• Outsole Karet Durabilitas Tinggi',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  // 5. Widget untuk Tombol Aksi (Sama seperti sebelumnya)
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              label: const Text('Keranjang'),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: FilledButton.icon(
              icon: const Icon(Icons.shopping_bag_outlined, size: 20),
              label: const Text('Beli Sekarang'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // --- Layout Utama (Sama seperti sebelumnya) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey[700]),
              onPressed: () {},
              tooltip: 'Favoritkan',
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double wideLayoutThreshold = 700.0;

          if (constraints.maxWidth >= wideLayoutThreshold) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout(context);
          }
        },
      ),
    );
  }

  // --- Metode untuk Membangun Layout Spesifik (Sama seperti sebelumnya) ---

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0, bottom: 16.0),
            child: ClipRRect( // Memberi border radius pada gambar
                borderRadius: BorderRadius.circular(16.0),
                child: _buildProductImage() // <-- Memanggil gambar yang sudah diperbarui
            ),
          ),
          _buildProductInfo(context),
          const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: _buildProductImage() // <-- Memanggil gambar yang sudah diperbarui
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, right: 24.0, bottom: 24.0),
            child: Column(
              children: [
                _buildProductInfo(context),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}