import 'package:flutter/material.dart';

class JadwalPage extends StatefulWidget {
  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final List<Map<String, String>> _jadwal = [
    {
      "kode": "14564014",
      "matkul": "Pemrograman Berbasis Mobile",
      "sks": "3",
      "hari": "Senin",
      "jam": "08:00-10:30",
      "ruang": "A",
      "kelas": "A",
    },
    {
      "kode": "14569001",
      "matkul": "E-Business",
      "sks": "3",
      "hari": "Senin",
      "jam": "10:30-13:00",
      "ruang": "A",
      "kelas": "A",
    },
    {
      "kode": "14568001",
      "matkul": "Metodologi Penelitian",
      "sks": "3",
      "hari": "Selasa",
      "jam": "11:20-13:50",
      "ruang": "A",
      "kelas": "A",
    },
    {
      "kode": "14564015",
      "matkul": "Prak. Pemrograman Berbasis Mobile",
      "sks": "1",
      "hari": "Selasa",
      "jam": "13:50-16:20",
      "ruang": "A",
      "kelas": "A",
    },
    {
      "kode": "14565001",
      "matkul": "Manajemen Proyek",
      "sks": "3",
      "hari": "Rabu",
      "jam": "09:40-12:10",
      "ruang": "A",
      "kelas": "A",
    },
    {
      "kode": "14569005",
      "matkul": "Enterprise Software Engineering",
      "sks": "3",
      "hari": "Kamis",
      "jam": "10:30-13:00",
      "ruang": "A",
      "kelas": "A",
    },
    {
      "kode": "14567001",
      "matkul": "Geoinformatika",
      "sks": "2",
      "hari": "Jumat",
      "jam": "08:00-09:40",
      "ruang": "A",
      "kelas": "A",
    },
  ];

  final List<String> _days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];
  int _currentDayIndex = 0;

  void _nextDay() {
    setState(() {
      _currentDayIndex = (_currentDayIndex + 1) % _days.length;
    });
  }

  void _prevDay() {
    setState(() {
      _currentDayIndex = (_currentDayIndex - 1 + _days.length) % _days.length;
    });
  }

  Icon _getIcon(String matkul) {
    if (matkul.toLowerCase().contains("prak")) {
      return Icon(Icons.settings, color: Colors.orange);
    } else {
      return Icon(Icons.book, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDay = _days[_currentDayIndex];
    List<Map<String, String>> filtered =
        _jadwal.where((item) => item['hari'] == selectedDay).toList();
    int totalSks = filtered.fold(
      0,
      (sum, item) => sum + int.parse(item['sks']!),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // implement refresh/export PDF
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fitur Export PDF coming soon...")),
          );
        },
        icon: Icon(Icons.picture_as_pdf),
        label: Text("Export PDF"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: _prevDay, icon: Icon(Icons.chevron_left)),
                DropdownButton<String>(
                  value: selectedDay,
                  items:
                      _days.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentDayIndex = _days.indexOf(val!);
                    });
                  },
                ),
                IconButton(
                  onPressed: _nextDay,
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),

            SizedBox(height: 8),
            Text(
              "Total SKS hari ini: $totalSks",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child:
                    filtered.isEmpty
                        ? Center(
                          child: Text('Tidak ada jadwal untuk hari ini.'),
                        )
                        : ListView.builder(
                          key: ValueKey<String>(selectedDay),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  _getIcon(item['matkul']!),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['matkul']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Jam: ${item['jam']} | SKS: ${item['sks']}",
                                        ),
                                        Text(
                                          "Kode: ${item['kode']} | Kelas: ${item['kelas']}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
