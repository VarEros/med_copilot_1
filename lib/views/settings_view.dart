import 'package:flutter/material.dart';
import 'package:med_copilot_1/themes.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Tema'),
            trailing: ToggleSwitch(
              totalSwitches: 2, 
              labels: const ['Claro', 'Oscuro'],
              initialLabelIndex: 0,
              changeOnTap: true,
              onToggle: (index) => themeProvider.toggleTheme()
            ),
          )
        ],
      ),
    );
  }
}