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
      title: 'Flutter Login Demo', // Judul aplikasi
      theme: ThemeData(
        // Tema dasar aplikasi.
        primarySwatch: Colors.teal, // Menggunakan warna tema yang berbeda
        useMaterial3: true, // Menggunakan Material Design 3
        // Anda bisa menambahkan kustomisasi tema lain di sini
        inputDecorationTheme: const InputDecorationTheme( // Contoh kustomisasi tema input
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( // Contoh kustomisasi tema tombol
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      // home menentukan widget yang akan ditampilkan sebagai layar utama.
      home: const LoginForm(), // Menggunakan LoginForm Anda sebagai layar utama
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}


// --- Login Form Widget (Kode Anda) ---
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // 1. GlobalKey untuk Form
  final _formKey = GlobalKey<FormState>();

  // 2. Controller (opsional, tapi baik untuk ditunjukkan)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 3. Variabel untuk menyimpan hasil setelah 'save'
  String _email = '';
  String _password = '';

  @override
  void dispose() {
    // 4. Dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // 5. Validasi form
    // Memeriksa apakah context masih valid sebelum menampilkan SnackBar
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      // 6. Jika valid, simpan form
      _formKey.currentState!.save();

      // 7. Proses data (misalnya, cetak atau kirim ke API)
      print('Form submitted successfully!');
      print('Email: $_email');
      print('Password: $_password'); // Harusnya tidak print password asli!

      // Tampilkan snackbar sebagai feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful for $_email'),
          backgroundColor: Colors.green, // Warna sukses
        ),
      );

      // Anda bisa navigasi ke halaman lain atau reset form
      // _formKey.currentState!.reset();
      // _emailController.clear();
      // _passwordController.clear();
    } else {
      print('Form validation failed.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red, // Warna error
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan AppBar dari MaterialApp, tidak perlu Scaffold lagi di sini
    // kecuali Anda butuh fitur Scaffold lain khusus untuk form ini.
    // Agar lebih konsisten, kita biarkan Scaffold di sini karena
    // LoginForm adalah 'halaman' utama yang ditampilkan oleh MaterialApp.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Gunakan warna primer tema
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // Warna teks AppBar
      ),
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView agar bisa di-scroll jika keyboard muncul
        padding: const EdgeInsets.all(24.0), // Tambah padding
        child: Form( // 8. Bungkus dengan Form widget
          key: _formKey, // Assign key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Email Field ---
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined), // Gunakan prefixIcon
                  // Menggunakan tema input dari MaterialApp
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  // Simple regex for basic email validation
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null; // Valid
                },
                onSaved: (value) {
                  _email = value ?? ''; // Simpan nilai saat form di-save
                },
              ),
              const SizedBox(height: 16),

              // --- Password Field ---
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline), // Gunakan prefixIcon
                  // Menggunakan tema input dari MaterialApp
                ),
                obscureText: true, // Sembunyikan teks password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null; // Valid
                },
                onSaved: (value) {
                  _password = value ?? ''; // Simpan nilai saat form di-save
                },
              ),
              const SizedBox(height: 32), // Beri jarak lebih sebelum tombol

              // --- Submit Button ---
              ElevatedButton(
                onPressed: _submitForm, // Panggil metode submit saat ditekan
                // Style diambil dari ElevatedButtonThemeData di MaterialApp
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}