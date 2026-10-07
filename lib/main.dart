import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'state/assessment_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'AIzaSyC5NzPNqRKB5AvIMS10VpmcLCl21pwLug0',
    authDomain: 'coding-urban-safety.firebaseapp.com',
    projectId: 'coding-urban-safety',
    storageBucket: 'coding-urban-safety.firebasestorage.app',
    messagingSenderId: '517797655079',
    appId: '1:517797655079:web:3a2e5b1af72feea64b1402',
    measurementId: 'G-0Q26VGG928',
  ),
);
  runApp(const CodingUrbanSafetyApp());
}

class CodingUrbanSafetyApp extends StatefulWidget {
  const CodingUrbanSafetyApp({super.key});

  @override
  State<CodingUrbanSafetyApp> createState() => _CodingUrbanSafetyAppState();
}

class _CodingUrbanSafetyAppState extends State<CodingUrbanSafetyApp> {
  final AssessmentState assessmentState = AssessmentState();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF5B4BDB);
    const background = Color(0xFFF6F6FA);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CODING URBAN SAFETY',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF24212F),
          titleTextStyle: TextStyle(
            color: Color(0xFF24212F),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            color: Color(0xFF24212F),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF24212F),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF4C4858),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: primary.withValues(alpha: 0.14),
          side: const BorderSide(color: Color(0xFFD8D5E3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF383346),
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD8D5E3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD8D5E3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      home: HomePage(assessmentState: assessmentState),
    );
  }
}
