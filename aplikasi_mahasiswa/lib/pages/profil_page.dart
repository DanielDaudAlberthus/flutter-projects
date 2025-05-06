import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const ProfilPage({super.key, required this.onThemeToggle});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama: Budi Santoso', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('NIM: 202501234', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('Email: budi@student.ac.id', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mode Gelap', style: TextStyle(fontSize: 16)),
              Switch(
                value: _isDarkMode,
                onChanged: (val) {
                  setState(() => _isDarkMode = val);
                  widget.onThemeToggle(val);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
