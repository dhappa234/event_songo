import 'package:flutter/material.dart';
import 'constants.dart';
import 'screen/login_screen.dart';
import 'screen/home_screen.dart';
import 'screen/detail_event_screen.dart';
import 'screen/upload_event_screen.dart';
import 'screen/profile_screen.dart';

void main() {
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
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const DetailEventScreen(),
        '/upload': (context) => const UploadEventScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}