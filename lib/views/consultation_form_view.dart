import 'package:flutter/material.dart';
import 'package:med_copilot_1/models/consultation.dart';
import 'package:med_copilot_1/models/patient.dart';
import 'package:med_copilot_1/utils.dart';
import 'package:med_copilot_1/viewmodels/consultation_view_model.dart';
import 'package:provider/provider.dart';

class ConsultationFormView extends StatefulWidget {
  final bool isEditMode;
  final Patient selectedPatient;

  const ConsultationFormView({super.key, this.isEditMode = false, required this.selectedPatient});

  @override
  State<ConsultationFormView> createState() => _ConsultationFormViewState();
}

class _ConsultationFormViewState extends State<ConsultationFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Agregar la consulta a través del ViewModel
      final consultationViewModel = Provider.of<ConsultationViewModel>(context, listen: false);

      final consultation = Consultation(
        id: widget.isEditMode ? consultationViewModel.selectedConsultation!.id : 0,
        description: _descripcionController.text,
        registrationDate: DateTime.now(),
        patient: widget.selectedPatient
      );

      widget.isEditMode ? consultationViewModel.updateConsultation(consultation) : consultationViewModel.createConsultation(consultation);
      Navigator.of(context).pop(); // Volver a la pantalla anterior
      if (!widget.isEditMode) Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    final consultationViewModel = Provider.of<ConsultationViewModel>(context, listen: false);

    if (widget.isEditMode && consultationViewModel.selectedConsultation != null) {
      // Prellenado de los datos para editar
      _descripcionController.text = consultationViewModel.selectedConsultation!.description;
    }
  }

  void _deleteConsultation() {
    final consultationViewModel = Provider.of<ConsultationViewModel>(context, listen: false);
    if (consultationViewModel.selectedConsultation != null) {
      consultationViewModel.removeConsultation(consultationViewModel.selectedConsultation!.id);
      Navigator.of(context).pop(); // Cierra el formulario después de eliminar
      if (!widget.isEditMode) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isEditMode ? AppBar(
        title: const Text('Editar Consulta'),
        actions: [IconButton(
          onPressed: () => showConfirmationDialog(
            context: context, 
            title: 'Eliminar Consulta', 
            message: 'eliminar la consulta del paciente ${widget.selectedPatient.name} ${widget.selectedPatient.lastname}', 
            onConfirm: _deleteConsultation
          ), 
          icon: const Icon(Icons.delete), iconSize: 25, padding: const EdgeInsets.all(16.0),
        )],
      ): AppBar(title: const Text('Agregar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Paciente: ${widget.selectedPatient.name} ${widget.selectedPatient.lastname} - ${widget.selectedPatient.personalId}'),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingresa la descripción de la consulta',
                ),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitForm,
                child: Text(widget.isEditMode ? 'Guardar Cambios' : 'Guardar Consulta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
