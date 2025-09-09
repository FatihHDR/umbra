import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/presentation/home_screen.dart';

class UmbraApp extends ConsumerWidget {
  const UmbraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const black = Color(0xFF121212);
    const red = Color(0xFFFF3B30);

    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        primary: red,
        secondary: red,
        surface: Color(0xFF1C1C1E),
        background: black,
      ),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: red),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: red, width: 1.2),
        ),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: black, elevation: 0),
      iconTheme: const IconThemeData(color: red),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: red,
        foregroundColor: Colors.white,
      ),
    );

    return MaterialApp(
      title: 'Umbra',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
