import 'package:flutter/foundation.dart';
import 'package:med_copilot_1/models/patient.dart';
import 'package:med_copilot_1/services/patient_service.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientService _patientService;
  List<Patient> _patients = [];
  Patient? _selectedPatient;

  PatientViewModel(this._patientService);

  List<Patient> get patients => _patients;
  Patient? get selectedPatient => _selectedPatient;

  // Cargar todos los pacientes
  Future<void> fetchPatients() async {
    try {
      _patients = await _patientService.fetchPatients();
      notifyListeners();
    } catch (e) {
      print('Error al cargar pacientes: $e');
    }
  }

  // Agregar paciente
  Future<void> createPatient(Patient patient) async {
    try {
      await _patientService.createPatient(patient);
      _patients.add(patient);
      notifyListeners();
    } catch (e) {
      print('Error al agregar paciente: $e');
    }
  }

  // Actualizar paciente
  Future<void> updatePatient(Patient patient) async {
    try {
      await _patientService.updatePatient(patient);
      int index = _patients.indexWhere((p) => p.id == patient.id);
      if (index != -1) {
        _patients[index] = patient;
        notifyListeners();
      }
    } catch (e) {
      print('Error al actualizar paciente: $e');
    }
  }

  // Eliminar paciente
  Future<void> removePatient(int id) async {
    try {
      await _patientService.deletePatient(id);
      _patients.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print('Error al eliminar paciente: $e');
    }
  }

  // Seleccionar un paciente para editar o ver detalles
  void selectPatient(Patient patient) {
    _selectedPatient = patient;
    notifyListeners();
  }

  void clearSelectedPatient() {
    _selectedPatient = null;
    notifyListeners();
  }
}