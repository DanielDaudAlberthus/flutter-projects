import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

void main() => runApp(const AdaptiveDemo());

class AdaptiveDemo extends StatelessWidget {
  const AdaptiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // ── data dummy
  final _items = List<String>.generate(20, (i) => 'Acara Kampus#${i + 1}');

  @override
  Widget build(BuildContext context) {
    // tujuan navigasi (akan otomatis menjadi BottomNav / Rail / Drawer)
    const destinations = <NavigationDestination>[
      NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
      NavigationDestination(icon: Icon(Icons.event), label: 'Acara'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
    ];

    return AdaptiveScaffold(
      useDrawer: false,                       // biarkan default drawer otomatis
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
      destinations: destinations,

      // 1️⃣Body untuk breakpoint *small* (<600dp)
      smallBody: (_) => _FeedGrid(cols: 1, items: _items),

      // 2️⃣Body default (medium&large≥600dp)
      body: (context) {
        final width = MediaQuery.of(context).size.width;
        // Material 3 guideline: Medium starts at 600dp, Expanded at 905dp.
        final cols = width < 905 ? 2 : 3;
        return _FeedGrid(cols: cols, items: _items);
      },
    );
  }
}

/// Grid/List sederhana agar layar mudah dikenali
class _FeedGrid extends StatelessWidget {
  const _FeedGrid({required this.cols, required this.items});
  final int cols;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: cols == 1 ? 5 : 3 / 2,
      ),
      itemBuilder: (_, i) => Card(
        elevation: 2,
        child: Center(
          child: Text(
            items[i],
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}