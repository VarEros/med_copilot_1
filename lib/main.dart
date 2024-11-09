import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:med_copilot_1/services/consultation_service.dart';
import 'package:med_copilot_1/services/patient_service.dart';
import 'package:med_copilot_1/themes.dart';
import 'package:med_copilot_1/utils.dart';
import 'package:med_copilot_1/viewmodels/consultation_view_model.dart';
import 'package:med_copilot_1/viewmodels/patient_view_model.dart';
import 'package:med_copilot_1/views/consultation_list_view.dart';
import 'package:med_copilot_1/views/patient_list_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}
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
        scaffoldMessengerKey: scaffoldKey,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: const SafeArea(child: HomeScreen()),
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
  void _onDestinationSelected(int index) => setState(() => _selectedIndex = index);

  // Lista de Widgets para cada sección
  final List<Widget> _screens = [
    const PatientListView(),
    const ConsultationListView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Mostrar NavigationRail en pantallas grandes y BottomNavigationBar en pantallas pequeñas
          if (MediaQuery.of(context).size.width > 600)
            NavigationRail(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              leading: getLogo(context),
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
          ? CurvedNavigationBar(
            index: 0,
            items: <Widget>[
              Icon(Icons.people, size: 30, color: Theme.of(context).colorScheme.onSurface),
              Icon(Icons.folder, size: 30, color: Theme.of(context).colorScheme.onSurface),
            ],
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            buttonBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: _onDestinationSelected,
            letIndexChange: (index) => true,
          )
          : null,
    );
  }
}