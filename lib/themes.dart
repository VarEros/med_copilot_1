import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
  brightness: Brightness.light,
);

final ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.kanit().fontFamily,
  colorScheme: lightScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: lightScheme.onSurface,
    foregroundColor: lightScheme.surface,
    centerTitle: true,
  ),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())
);

final darkScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
  brightness: Brightness.dark,
);

final ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.kanit().fontFamily,
  colorScheme: darkScheme,
  appBarTheme: const AppBarTheme(centerTitle: true),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  listTileTheme: ListTileThemeData(tileColor: darkScheme.surfaceContainer)
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