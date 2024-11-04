import 'package:flutter/material.dart';
import 'package:med_copilot_1/viewmodels/patient_view_model.dart';
import 'package:med_copilot_1/views/consultation_list_view.dart';
import 'package:provider/provider.dart';
import 'patient_form_view.dart';

class PatientListView extends StatefulWidget {
  const PatientListView({super.key});

  @override
  State<PatientListView> createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
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
          patientViewModel.clearSelectedPatient();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PatientFormView(isEditMode: false),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}