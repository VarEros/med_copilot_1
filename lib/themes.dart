import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lightScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
  brightness: Brightness.light,
);
final darkScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
  brightness: Brightness.dark,
);

final lightTheme = ThemeData(
  fontFamily: GoogleFonts.kanit().fontFamily,
  colorScheme: lightScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: lightScheme.onSurface,
    foregroundColor: lightScheme.surface,
    centerTitle: true,
  ),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())
);

final darkTheme = ThemeData(
  fontFamily: GoogleFonts.kanit().fontFamily,
  colorScheme: darkScheme,
  appBarTheme: const AppBarTheme(centerTitle: true),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  listTileTheme: ListTileThemeData(tileColor: darkScheme.surfaceContainer)
);


List<String?> fonts = [GoogleFonts.kanit().fontFamily, GoogleFonts.roboto().fontFamily, GoogleFonts.kanit().fontFamily];

class ThemeProvider with ChangeNotifier {
  late ThemeMode _themeMode;
  late String _fontType;

  ThemeMode get themeMode => _themeMode;
  String get fontStyle => _fontType;

  Future<void> toggleTheme() async {
    if(_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await _saveThemeToPreferences('dark');
    } else {
      _themeMode = ThemeMode.light;
      await _saveThemeToPreferences('light');
    }
    notifyListeners();
  }

  Future<void> _saveFontPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font', _fontType);
    
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';

    _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveThemeToPreferences(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }
}

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