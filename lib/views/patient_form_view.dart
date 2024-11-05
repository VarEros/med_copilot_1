// views/patient_form_view.dart
import 'package:flutter/material.dart';
import 'package:med_copilot_1/Utils.dart';
import 'package:med_copilot_1/models/patient.dart';
import 'package:med_copilot_1/viewmodels/patient_view_model.dart';
import 'package:provider/provider.dart';

class PatientFormView extends StatefulWidget {
  final bool isEditMode;

  const PatientFormView({super.key, this.isEditMode = false});

  @override
  State<PatientFormView> createState() => _PatientFormViewState();
}

class _PatientFormViewState extends State<PatientFormView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _personalIdController;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  DateTime? _birthdate;

  @override
  void initState() {
    super.initState();
    final patientViewModel = Provider.of<PatientViewModel>(context, listen: false);

    _personalIdController = TextEditingController();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    if (widget.isEditMode && patientViewModel.selectedPatient != null) {
      // Prellenado de los datos para editar
      _personalIdController.text = patientViewModel.selectedPatient!.personalId;
      _nameController.text = patientViewModel.selectedPatient!.name;
      _lastNameController.text = patientViewModel.selectedPatient!.lastname;
      _phoneController.text = patientViewModel.selectedPatient!.phone ?? '';
      _emailController.text = patientViewModel.selectedPatient!.email ?? '';
      _birthdate = patientViewModel.selectedPatient!.birthdate;
    }
  }

  @override
  void dispose() {
    _personalIdController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime(2000), // Fecha inicial del selector
      firstDate: DateTime(1900), // Primer año disponible
      lastDate: DateTime.now(), // Última fecha disponible
    );
    if (picked != null && picked != _birthdate) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_birthdate == null) {
        // Mostrar mensaje de error si no se ha seleccionado una fecha
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, selecciona una fecha de nacimiento')));
        return;
      }
      
      final patientViewModel = Provider.of<PatientViewModel>(context, listen: false);

      final patient = Patient(
        id: widget.isEditMode ? patientViewModel.selectedPatient!.id : 0,
        personalId: _personalIdController.text,
        name: _nameController.text,
        lastname: _lastNameController.text,
        birthdate: _birthdate!,
        phone: _phoneController.text,
        email: _emailController.text,
        followUp: true
      );

      if (widget.isEditMode) {
        patientViewModel.updatePatient(patient);
      } else {
        patientViewModel.createPatient(patient);
      }

      Navigator.of(context).pop(); // Cierra el formulario después de guardar o actualizar
    }
  }

  void _deletePatient() {
    final patientViewModel = Provider.of<PatientViewModel>(context, listen: false);
    if (patientViewModel.selectedPatient != null) {
      patientViewModel.removePatient(patientViewModel.selectedPatient!.id);
      Navigator.of(context).pop(); // Cierra el formulario después de eliminar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditMode ? 'Editar Paciente' : 'Agregar Paciente')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _personalIdController,
                  decoration: const InputDecoration(labelText: 'Cedula'),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombres'),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  maxLength: 8,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electronico'),
                  validator: validateEmail,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: _birthdate != null ? getDateString(_birthdate!) : ''),
                      decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                      validator: (value) => _birthdate == null ? 'Selecciona una fecha' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.isEditMode ? 'Guardar Cambios' : 'Guardar Paciente'),
                ),
                if (widget.isEditMode) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _deletePatient,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Eliminar Paciente'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}
}
