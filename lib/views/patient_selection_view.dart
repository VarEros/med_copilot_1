import 'package:flutter/material.dart';
import 'package:med_copilot_1/viewmodels/patient_view_model.dart';
import 'package:med_copilot_1/views/consultation_form_view.dart';
import 'package:provider/provider.dart';

class PatientSelectionView extends StatelessWidget {
  const PatientSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final patientViewModel = Provider.of<PatientViewModel>(context);
    final patients = patientViewModel.patients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Paciente'),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return ListTile(
            title: Text(patient.name),
            subtitle: Text('cedula: ${patient.personalId}'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ConsultationFormView(
                    isEditMode: false,
                    selectedPatient: patient,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}