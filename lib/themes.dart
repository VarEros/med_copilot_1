import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData baseTheme = ThemeData(
  fontFamily: GoogleFonts.kanit().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF191d17),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())
);

final ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.kanit().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(centerTitle: true),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())
);

Widget getLogo(BuildContext context) {
  return Column(
    children: [
      Image.asset(
        'assets/images/logo.png', 
        color: Theme.of(context).colorScheme.onSurface,
        filterQuality: FilterQuality.medium,
        scale: 8,
      ),
      Text('Med Copilot', style: TextStyle(fontFamily: GoogleFonts.oswald().fontFamily, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20)
    ],
  );
} 