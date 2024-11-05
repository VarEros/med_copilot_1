import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_copilot_1/services/consultation_service.dart';
import 'package:med_copilot_1/services/patient_service.dart';
import 'package:med_copilot_1/viewmodels/consultation_view_model.dart';
import 'package:med_copilot_1/viewmodels/patient_view_model.dart';
import 'package:med_copilot_1/views/consultation_list_view.dart';
import 'package:med_copilot_1/views/patient_list_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

final ThemeData baseTheme = ThemeData(
  fontFamily: GoogleFonts.raleway().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    elevation: 20
    
  ),
  brightness: Brightness.light,
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientViewModel(PatientService())),
        ChangeNotifierProvider(create: (_) => ConsultationViewModel(ConsultationService()))
      ],
      child: MaterialApp(
        theme: baseTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de Widgets para cada sección
  final List<Widget> _screens = [
    const PatientListView(),
    const ConsultationListView()
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Mostrar NavigationRail en pantallas grandes y BottomNavigationBar en pantallas pequeñas
          if (MediaQuery.of(context).size.width > 600)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  selectedIcon: Icon(Icons.people_outline),
                  label: Text('Pacientes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.folder),
                  selectedIcon: Icon(Icons.folder_outlined),
                  label: Text('Consultas'),
                ),
              ],
            ),
          // Pantallas de contenido
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      // BottomNavigationBar para pantallas más pequeñas
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onDestinationSelected,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Pacientes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder),
                  label: 'Consultas',
                ),
              ],
            )
          : null,
    );
  }
}