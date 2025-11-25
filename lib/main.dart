import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants.dart';
// Asumsi: Struktur folder yang benar adalah 'screens/'
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_event_screen.dart';
import 'screens/upload_event_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/regrister_screen.dart';

// Ganti dengan URL dan KEY Supabase Anda!
// Diletakkan di sini agar mudah diakses di seluruh aplikasi (meskipun best practice adalah menggunakan .env)
const String supabaseUrl = 'https://telfiwtilsxlegyzyeqt.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlbGZpd3RpbHN4bGVneXp5ZXF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwMjI4NzQsImV4cCI6MjA3OTU5ODg3NH0.1UQmAQGwK-SGTXgjz9H672lwH-r3WIcbmR_VIX69W9g';

// Tambahkan getter untuk memudahkan akses Supabase Client di mana pun
final supabase = Supabase.instance.client; // <-- Tambahan ini sangat berguna!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // === INISIALISASI SUPABASE ===
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    // Jika Anda ingin menggunakan Auth atau Local Storage:
    // debug: true, // Opsional: Aktifkan untuk debugging Supabase
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVENTSONGO!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        // Asumsi kBackgroundColor didefinisikan di constants.dart
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      initialRoute: '/',
      routes: {
        // Tambahan rute untuk menangani status autentikasi
        '/': (context) {
          // Cek apakah pengguna sudah login
          final session = supabase.auth.currentSession;
          if (session != null) {
            // Jika sudah login, langsung ke HomeScreen
            return const HomeScreen();
          } else {
            // Jika belum, tetap di LoginScreen
            return const LoginScreen();
          }
        },
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const DetailEventScreen(),
        '/upload': (context) => const UploadEventScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}