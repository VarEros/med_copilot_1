import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:med_copilot_1/models/patient.dart';
import 'package:med_copilot_1/utils.dart';
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
      _personalIdController.text = getPersonalIdFormated(patientViewModel.selectedPatient!.personalId);
      _nameController.text = patientViewModel.selectedPatient!.name;
      _lastNameController.text = patientViewModel.selectedPatient!.lastname;
      _phoneController.text = patientViewModel.selectedPatient!.phone != null ? getPhoneFormated(patientViewModel.selectedPatient!.phone!) : '';
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
      initialDatePickerMode: DatePickerMode.year,
      initialDate: _birthdate ?? DateTime(2000), // Fecha inicial del selector
      firstDate: DateTime(1900), // Primer año disponible
      lastDate: DateTime.now(), // Última fecha disponible
    );
    if (picked != null && picked != _birthdate) {
      setState(() => _birthdate = picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final patientViewModel = Provider.of<PatientViewModel>(context, listen: false);

      final patient = Patient(
        id: widget.isEditMode ? patientViewModel.selectedPatient!.id : 0,
        personalId: _personalIdController.text.replaceAll(RegExp(r'-'), ''),
        name: _nameController.text,
        lastname: _lastNameController.text,
        birthdate: _birthdate!,
        phone: _phoneController.text.replaceAll(RegExp(r'-'), ''),
        email: _emailController.text,
        followUp: true
      );

      widget.isEditMode ? patientViewModel.updatePatient(patient) : patientViewModel.createPatient(patient);
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
      appBar: widget.isEditMode ? AppBar(
        title: const Text('Editar Paciente'), 
        actions: [IconButton(
          onPressed: () => showConfirmationDialog(
            context: context, 
            title: 'Eliminar Paciente', 
            message: 'eliminar al paciente ${_nameController.text} ${_lastNameController.text}', 
            onConfirm: _deletePatient
          ), 
          icon: const Icon(Icons.delete), iconSize: 25, padding: const EdgeInsets.all(16.0),
        )],
      ): AppBar(title: const Text('Agregar Paciente')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _personalIdController,
                  decoration: const InputDecoration(labelText: 'Cedula', counterText: ''),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  maxLength: 17,
                  inputFormatters: [cedMaskFormatter, UpperCaseTextFormatter()],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombres', counterText: ''),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  maxLength: 30,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Apellidos', counterText: ''),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  maxLength: 30,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono', counterText: ''),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                  maxLength: 9,
                  inputFormatters: [phoneMaskFormatter],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electronico', counterText: ''),
                  validator: validateEmail,
                  maxLength: 100,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: TextEditingController(text: _birthdate != null ? getDateString(_birthdate!) : ''),
                  decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                  validator: (value) => _birthdate == null ? 'Campo obligatorio' : null,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  mouseCursor: SystemMouseCursors.click,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _submitForm,
                  child: Text(widget.isEditMode ? 'Guardar Cambios' : 'Guardar Paciente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '####-####', 
    type: MaskAutoCompletionType.lazy
  );

    final cedMaskFormatter = MaskTextInputFormatter(
    mask: '###-######-####A', 
    type: MaskAutoCompletionType.lazy
  );

  String getPhoneFormated(String phone) => phone.replaceRange(4, null, '-${phone.substring(4)}');
  String getPersonalIdFormated(String ced) => '${ced.substring(0,3)}-${ced.substring(3,9)}-${ced.substring(9,14)}';

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
