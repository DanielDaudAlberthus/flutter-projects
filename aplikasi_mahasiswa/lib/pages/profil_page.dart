import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

class ProfilPage extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const ProfilPage({super.key, required this.onThemeToggle});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _isDarkMode = false;

  // Variabel untuk menyimpan path file gambar
  File? _profileImage;
  String _profileImagePath = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load gambar profil saat halaman dibuka
    _loadProfileImage();
  }

  // Fungsi untuk memuat gambar dari storage
  Future<void> _loadProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _profileImagePath = prefs.getString('profile_image_path') ?? '';
        if (_profileImagePath.isNotEmpty) {
          _profileImage = File(_profileImagePath);
        }
      });
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  // Fungsi untuk menyimpan path gambar ke storage
  Future<void> _saveProfileImagePath(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', path);
    } catch (e) {
      print('Error saving profile image path: $e');
    }
  }

  // Request permissions
  Future<bool> _requestPermissions(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      // For gallery access
      if (await _isAndroid13OrHigher()) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    }

    return status.isGranted;
  }

  // Check if device is running Android 13 or higher
  Future<bool> _isAndroid13OrHigher() async {
    // This is a simple method, you might want to use a more robust solution like device_info_plus
    return true; // Assume Android 13+ for safety
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _getImageFromGallery() async {
    try {
      // Request permissions first
      bool hasPermission = await _requestPermissions(ImageSource.gallery);

      if (!hasPermission) {
        _showPermissionDeniedDialog('storage');
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Mengurangi ukuran file
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _profileImagePath = pickedFile.path;
        });
        // Simpan path gambar
        await _saveProfileImagePath(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      _showErrorDialog('Terjadi kesalahan saat mengakses galeri');
    }
  }

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> _getImageFromCamera() async {
    try {
      // Request camera permission
      bool hasPermission = await _requestPermissions(ImageSource.camera);

      if (!hasPermission) {
        _showPermissionDeniedDialog('camera');
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _profileImagePath = pickedFile.path;
        });
        // Simpan path gambar
        await _saveProfileImagePath(pickedFile.path);
      }
    } catch (e) {
      print('Error taking image from camera: $e');
      _showErrorDialog('Terjadi kesalahan saat mengakses kamera');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Show permission denied dialog
  void _showPermissionDeniedDialog(String permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Izin Diperlukan'),
          content: Text(
            'Aplikasi memerlukan izin $permission untuk fitur ini. Silakan aktifkan di pengaturan aplikasi.',
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Buka Pengaturan'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog pilihan sumber gambar
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromCamera();
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Hapus Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _profileImage = null;
                      _profileImagePath = '';
                    });
                    _saveProfileImagePath('');
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan foto profil
            Container(
              height: 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      isDarkTheme
                          ? [Colors.blueGrey[800]!, Colors.blueGrey[600]!]
                          : [Colors.blue[700]!, Colors.blue[500]!],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Foto profil dengan border lingkaran
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  _profileImage != null
                                      ? FileImage(_profileImage!)
                                          as ImageProvider
                                      : AssetImage('assets/Daniel.jpg'),
                              child:
                                  _profileImage != null &&
                                          _profileImagePath.isEmpty
                                      ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey[600],
                                      )
                                      : null,
                            ),
                            // Tombol edit foto
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap:
                                    () => _showImageSourceActionSheet(context),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[600],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Nama dengan styling yang elegan
                      Text(
                        'Daniel Daud Alberthus',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      // NPM dengan styling
                      Text(
                        'NPM: 4522210055',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Rest of the UI remains the same

            // Body dengan informasi profil
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul untuk bagian informasi
                  Text(
                    'Informasi Profil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white : Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Card untuk informasi kontak
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Informasi email
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isDarkTheme
                                        ? Colors.blueGrey[700]
                                        : Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.email_outlined,
                                color:
                                    isDarkTheme
                                        ? Colors.white
                                        : Colors.blue[700],
                              ),
                            ),
                            title: Text('Email'),
                            subtitle: Text('4522210055@univpancasila.ac.id'),
                          ),

                          Divider(),

                          // Informasi kampus (tambahan)
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isDarkTheme
                                        ? Colors.blueGrey[700]
                                        : Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.school_outlined,
                                color:
                                    isDarkTheme
                                        ? Colors.white
                                        : Colors.blue[700],
                              ),
                            ),
                            title: Text('Status'),
                            subtitle: Text('Mahasiswa Aktif'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Toggle pengaturan tema
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SwitchListTile(
                        secondary: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                isDarkTheme
                                    ? Colors.blueGrey[700]
                                    : Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color:
                                isDarkTheme ? Colors.white : Colors.blue[700],
                          ),
                        ),
                        title: Text('Mode Gelap'),
                        subtitle: Text(_isDarkMode ? 'Aktif' : 'Nonaktif'),
                        value: _isDarkMode,
                        onChanged: (val) {
                          setState(() => _isDarkMode = val);
                          widget.onThemeToggle(val);
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Card untuk tombol sosial media (opsional)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Social Media',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSocialButton(
                                icon: Icons.language,
                                color: Colors.blue,
                                onPressed: () {},
                              ),
                              _buildSocialButton(
                                icon: Icons.alternate_email,
                                color: Colors.red,
                                onPressed: () {},
                              ),
                              _buildSocialButton(
                                icon: Icons.forum,
                                color: Colors.green,
                                onPressed: () {},
                              ),
                              _buildSocialButton(
                                icon: Icons.bookmark,
                                color: Colors.orange,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membuat tombol sosial media
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
