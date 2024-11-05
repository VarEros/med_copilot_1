import 'package:flutter/material.dart';
import 'package:med_copilot_1/viewmodels/patient_view_model.dart';
import 'package:med_copilot_1/views/consultation_list_view.dart';
import 'package:med_copilot_1/views/scanner_view.dart';
import 'package:provider/provider.dart';
import 'patient_form_view.dart';

class PatientListView extends StatefulWidget {
  const PatientListView({super.key});

  @override
  State<PatientListView> createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  String? patientString;
  @override
  void initState() {
    super.initState();
    // Llamamos a fetchPatients solo una vez al inicializar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientViewModel>(context, listen: false).fetchPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientViewModel = Provider.of<PatientViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: patientViewModel.patients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: patientViewModel.patients.length,
              itemBuilder: (context, index) {
                final patient = patientViewModel.patients[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(patient.calculateAge.toString())),
                  title: Text('${patient.name} ${patient.lastname}'),
                  subtitle: Text(patient.personalId),
                  trailing: IconButton(
                    icon: const Icon(Icons.folder),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConsultationListView(patient: patient),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    patientViewModel.selectPatient(patient);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PatientFormView(isEditMode: true),
                    ));
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptionsDialog(context, patientViewModel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

   void _showOptionsDialog(BuildContext context, PatientViewModel patientViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccione una opción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Escanear QR'),
                onTap: () async {
                  Navigator.pop(context); // Cierra el diálogo
                  patientString = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScannerView(),
                    ),
                  );
                  patientViewModel.createPatientFromQR(patientString!);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rellenar Formulario'),
                onTap: () {
                  Navigator.pop(context); // Cierra el diálogo
                  patientViewModel.clearSelectedPatient();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PatientFormView(isEditMode: false),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}