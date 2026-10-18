import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'services/app_preferences.dart';
import 'services/draft_storage.dart';
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
  final assessmentState = AssessmentState();
  await DraftStorage(assessmentState).initialize();
  await AppPreferences.load();
  runApp(CodingUrbanSafetyApp(assessmentState: assessmentState));
}

class CodingUrbanSafetyApp extends StatefulWidget {
  const CodingUrbanSafetyApp({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  State<CodingUrbanSafetyApp> createState() => _CodingUrbanSafetyAppState();
}

class _CodingUrbanSafetyAppState extends State<CodingUrbanSafetyApp> {


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppPreferences.instance,
      builder: (context, _) {
        // Read palette within the listener rebuild for instant switching.
        final primary = AppPreferences.instance.accent;
        final background = Color.alphaBlend(
          primary.withValues(alpha: 0.065), const Color(0xFFF7F2E9));
        return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: AppPreferences.instance.themeMode,
      locale: Locale(AppPreferences.instance.language),
      title: 'CODING URBAN SAFETY',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          surface: Color.alphaBlend(primary.withValues(alpha: 0.035), const Color(0xFFFFFCF6)),
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color.alphaBlend(primary.withValues(alpha: 0.06), const Color(0xFFFFFCF6)),
          foregroundColor: Color(0xFF202A30),
          titleTextStyle: TextStyle(
            color: Color(0xFF202A30),
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
            color: Color(0xFF202A30),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202A30),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF53615D),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: primary.withValues(alpha: 0.14),
          side: const BorderSide(color: Color(0xFFDCDDD6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF202A30),
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCDDD6)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCDDD6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark),
        scaffoldBackgroundColor: Color.alphaBlend(primary.withValues(alpha: 0.10), const Color(0xFF17171B)),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.alphaBlend(primary.withValues(alpha: 0.13), const Color(0xFF232228)),
          foregroundColor: const Color(0xFFF3F1F6),
          titleTextStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
            color: Color(0xFFF3F1F6), letterSpacing: 0.4),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
            color: Color(0xFFF5F2F7)),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
            color: Color(0xFFF5F2F7)),
          bodyLarge: TextStyle(fontSize: 16, height: 1.5,
            color: Color(0xFFD9D4DF)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF35323B),
          selectedColor: primary.withValues(alpha: 0.35),
          side: const BorderSide(color: Color(0xFF625D69)),
          labelStyle: const TextStyle(color: Color(0xFFF5F2F7),
            fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF302D35),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      home: HomePage(assessmentState: widget.assessmentState),
    );
      },
    );
  }
}
