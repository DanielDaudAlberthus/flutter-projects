import 'package:flutter/material.dart';
import 'pages/basic_gestures_page.dart';
import 'pages/drag_pan_page.dart';
import 'pages/gesture_arena_page.dart';
import 'pages/advanced_widgets_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gesture Playground',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Gesture Playground'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Dasar'),
              Tab(text: 'Drag & Pan'),
              Tab(text: 'Arena Gestur'),
              Tab(text: 'Widget Lanjutan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BasicGesturesPage(),
            DragPanPage(),
            GestureArenaPage(),
            AdvancedWidgetsPage(),
          ],
        ),
      ),
    );
  }
}