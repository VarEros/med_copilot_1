import 'package:flutter/material.dart';
import 'package:med_copilot_1/Utils.dart';
import 'package:med_copilot_1/models/patient.dart';
import 'package:med_copilot_1/viewmodels/consultation_view_model.dart';
import 'package:med_copilot_1/views/consultation_form_view.dart';
import 'package:med_copilot_1/views/patient_selection_view.dart';
import 'package:provider/provider.dart';

class ConsultationListView extends StatefulWidget {
  final Patient? patient;
  const ConsultationListView({super.key, this.patient});

  @override
  State<ConsultationListView> createState() => _ConsultationListViewState();
}

class _ConsultationListViewState extends State<ConsultationListView> {
    @override
    void initState() {
      super.initState();
      // Llamamos a fetchPatients solo una vez al inicializar el widget
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(widget.patient != null) {
          Provider.of<ConsultationViewModel>(context, listen: false).fetchConsultationsByPatient(widget.patient!.id);
        } else {
          Provider.of<ConsultationViewModel>(context, listen: false).fetchConsultations();
        }
        
      });
    }

  @override
  Widget build(BuildContext context) {
    final consultationViewModel = Provider.of<ConsultationViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.patient != null ? 'Consultas de ${widget.patient!.name} ${widget.patient!.lastname}' : 'Consultas recientes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>  Divider(height: 10, color: colorScheme.surface),
          itemCount: consultationViewModel.consultations.length,
          itemBuilder: (context, index) {
            final consultation = consultationViewModel.consultations[index];
            return ListTile(
              tileColor: colorScheme.brightness == Brightness.dark ? colorScheme.surfaceContainer : null,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text('${consultation.patient.name} ${consultation.patient.lastname}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(getDateString(consultation.registrationDate!)),
              onTap: () {
                consultationViewModel.selectConsultation(consultation);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ConsultationFormView(isEditMode: true, selectedPatient: consultation.patient),
                ));
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          consultationViewModel.clearSelectedConsultation();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => widget.patient != null ? ConsultationFormView(selectedPatient: widget.patient!) : const PatientSelectionView()
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}