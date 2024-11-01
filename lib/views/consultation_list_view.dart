import 'package:flutter/material.dart';
import 'package:med_copilot_1/viewmodels/consultation_view_model.dart';
import 'package:med_copilot_1/views/consultation_form_view.dart';
import 'package:med_copilot_1/views/patient_selection_view.dart';
import 'package:provider/provider.dart';

class ConsultationListView extends StatefulWidget {
  const ConsultationListView({super.key});

  @override
  State<ConsultationListView> createState() => _ConsultationListViewState();
}

class _ConsultationListViewState extends State<ConsultationListView> {
    @override
    void initState() {
      super.initState();
      // Llamamos a fetchPatients solo una vez al inicializar el widget
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ConsultationViewModel>(context, listen: false).fetchConsultations();
      });
    }

  @override
  Widget build(BuildContext context) {
    final consultationViewModel = Provider.of<ConsultationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Consultas')),
      body: ListView.builder(
        itemCount: consultationViewModel.consultations.length,
        itemBuilder: (context, index) {
          final consultation = consultationViewModel.consultations[index];
          return ListTile(
            title: Text(consultation.patient.name),
            subtitle: Text(consultation.registrationDate!.toIso8601String()),
            onTap: () {
              consultationViewModel.selectConsultation(consultation);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ConsultationFormView(isEditMode: true, selectedPatient: consultation.patient),
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          consultationViewModel.clearSelectedConsultation();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PatientSelectionView()
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}