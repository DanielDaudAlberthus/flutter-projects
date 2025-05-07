import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, String>> _jadwal = [
    {
      "kode": "14564014",
      "matkul": "Pemrograman Berbasis Mobile",
      "sks": "3",
      "hari": "Senin",
      "jam": "08:00-10:30",
      "ruang": "203",
      "kelas": "A",
    },
    {
      "kode": "14569001",
      "matkul": "E-Business",
      "sks": "3",
      "hari": "Senin",
      "jam": "10:30-13:00",
      "ruang": "209",
      "kelas": "A",
    },
    {
      "kode": "14568001",
      "matkul": "Metodologi Penelitian",
      "sks": "3",
      "hari": "Selasa",
      "jam": "11:20-13:50",
      "ruang": "307",
      "kelas": "A",
    },
    {
      "kode": "14564015",
      "matkul": "Prak. Pemrograman Berbasis Mobile",
      "sks": "1",
      "hari": "Selasa",
      "jam": "13:50-16:20",
      "ruang": "Lab Komputer",
      "kelas": "A",
    },
    {
      "kode": "14565001",
      "matkul": "Manajemen Proyek",
      "sks": "3",
      "hari": "Rabu",
      "jam": "09:40-12:10",
      "ruang": "309",
      "kelas": "A",
    },
    {
      "kode": "14569005",
      "matkul": "Enterprise Software Engineering",
      "sks": "3",
      "hari": "Kamis",
      "jam": "10:30-13:00",
      "ruang": "207",
      "kelas": "A",
    },
    {
      "kode": "14567001",
      "matkul": "Geoinformatika",
      "sks": "2",
      "hari": "Jumat",
      "jam": "08:00-09:40",
      "ruang": "415",
      "kelas": "A",
    },
  ];

  final List<String> _days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];

  @override
  void initState() {
    super.initState();

    // Menentukan hari aktif berdasarkan hari ini
    final today = DateFormat('EEEE').format(DateTime.now());
    int initialIndex = 0;

    switch (today.toLowerCase()) {
      case 'monday':
        initialIndex = 0; // Senin
        break;
      case 'tuesday':
        initialIndex = 1; // Selasa
        break;
      case 'wednesday':
        initialIndex = 2; // Rabu
        break;
      case 'thursday':
        initialIndex = 3; // Kamis
        break;
      case 'friday':
        initialIndex = 4; // Jumat
        break;
      default:
        initialIndex = 0; // Default ke Senin
    }

    _tabController = TabController(
      length: _days.length,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getMataKuliahColor(String matkul) {
    if (matkul.toLowerCase().contains("prak")) {
      return Colors.orange.shade100;
    } else if (matkul.toLowerCase().contains("mobile")) {
      return Colors.blue.shade100;
    } else if (matkul.toLowerCase().contains("enterprise")) {
      return Colors.green.shade100;
    } else if (matkul.toLowerCase().contains("proyek")) {
      return Colors.purple.shade100;
    } else if (matkul.toLowerCase().contains("business")) {
      return Colors.amber.shade100;
    } else if (matkul.toLowerCase().contains("penelitian")) {
      return Colors.red.shade100;
    } else {
      return Colors.teal.shade100;
    }
  }

  IconData _getCourseIcon(String matkul) {
    if (matkul.toLowerCase().contains("prak")) {
      return Icons.science;
    } else if (matkul.toLowerCase().contains("mobile")) {
      return Icons.phone_android;
    } else if (matkul.toLowerCase().contains("enterprise")) {
      return Icons.business;
    } else if (matkul.toLowerCase().contains("proyek")) {
      return Icons.assignment;
    } else if (matkul.toLowerCase().contains("business")) {
      return Icons.shopping_cart;
    } else if (matkul.toLowerCase().contains("penelitian")) {
      return Icons.search;
    } else if (matkul.toLowerCase().contains("geo")) {
      return Icons.public;
    } else {
      return Icons.book;
    }
  }

  String _formatJam(String jam) {
    return jam.replaceAll('-', ' - ');
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Scaffold normal tanpa bottom navigasi atau overlay
    return Scaffold(
      // Menghilangkan resizeToAvoidBottomInset jika ada
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Jadwal Kuliah',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 150, 66, 142),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.picture_as_pdf,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Fitur Export PDF coming soon..."),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            tooltip: 'Export PDF',
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Jadwal diperbarui"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ), // Tambahkan padding di bawah
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              tabs:
                  _days.map((day) {
                    final jadwalHariIni =
                        _jadwal.where((item) => item['hari'] == day).toList();
                    final totalSks = jadwalHariIni.fold(
                      0,
                      (sum, item) => sum + int.parse(item['sks']!),
                    );

                    return Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            children: [
                              Text(
                                day,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '$totalSks SKS',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
      // Gunakan SafeArea untuk menghindari overlay sistem
      body: SafeArea(
        // Atau tambahkan padding bottom jika diperlukan
        bottom: true,
        child: TabBarView(
          controller: _tabController,
          children:
              _days.map((day) {
                final jadwalHariIni =
                    _jadwal.where((item) => item['hari'] == day).toList();

                if (jadwalHariIni.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada jadwal untuk hari $day',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Bungkus ListView dengan Padding untuk memberikan ruang di bawah
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 80,
                  ), // Tambahkan padding bottom untuk menghindari FAB
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: jadwalHariIni.length,
                    itemBuilder: (context, index) {
                      final item = jadwalHariIni[index];
                      final backgroundColor = _getMataKuliahColor(
                        item['matkul']!,
                      );
                      final borderColor = backgroundColor.withOpacity(0.7);

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              backgroundColor,
                              backgroundColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            // Header card dengan mata kuliah dan waktu
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getCourseIcon(item['matkul']!),
                                      color: Theme.of(context).primaryColor,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['matkul']!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              _formatJam(item['jam']!),
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${item['sks']} SKS',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Detail informasi
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  _buildDetailItem(
                                    Icons.code,
                                    'Kode MK',
                                    item['kode']!,
                                  ),
                                  _buildDetailItem(
                                    Icons.meeting_room,
                                    'Ruang',
                                    item['ruang']!,
                                  ),
                                  _buildDetailItem(
                                    Icons.class_,
                                    'Kelas',
                                    item['kelas']!,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
        ),
      ),
      // Tambahkan extendBody: false untuk mencegah overlap dengan bottom navigation
      extendBody: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // Implementasi tambah jadwal baru
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Fitur tambah jadwal coming soon..."),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      // PASTIKAN TIDAK ADA bottomNavigationBar atau bottomSheet yang diatur di sini
      // jika Anda memiliki bottomNavigationBar, pastikan tidak memiliki teks "BOTTOM OVERLAY"
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
