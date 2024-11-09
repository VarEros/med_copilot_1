import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:med_copilot_1/models/consultation.dart';
import 'package:med_copilot_1/services/consultation_service.dart';
import 'package:med_copilot_1/utils.dart';

class ConsultationViewModel extends ChangeNotifier {
  final ConsultationService _consultationService;
  final SnackbarManager _snackbarManager = SnackbarManager('Consulta Guardada');
  List<Consultation> _consultations = [];
  Consultation? _selectedConsultation;

  ConsultationViewModel(this._consultationService);

  List<Consultation> get consultations => _consultations;
  Consultation? get selectedConsultation => _selectedConsultation;

// Cargar todas las consultas
  Future<void> fetchConsultations() async {
    try {
      _consultations = await _consultationService.fetchConsultations();
      notifyListeners();
    } catch (e) {
      print('Error al cargar consultas: $e');
    }
  }

  // Cargar todas las consultas
  Future<void> fetchConsultationsByPatient(int patientId) async {
    try {
      _consultations = await _consultationService.fetchConsultationsByPatient(patientId);
      notifyListeners();
    } catch (e) {
      print('Error al cargar consultas: $e');
    }
  }

  // Agregar consulta
  Future<void> createConsultation(Consultation consultation) async {
    try {
      await _consultationService.createConsultation(consultation);
      _snackbarManager.successSnackbar();
      _consultations.add(consultation);
      notifyListeners();
    } catch (e) {
      print('Error al agregar consulta: $e');
    }
  }

  // Actualizar consulta
  Future<void> updateConsultation(Consultation consultation) async {
    try {
      await _consultationService.updateConsultation(consultation);
      int index = _consultations.indexWhere((c) => c.id == consultation.id);
      if (index != -1) {
        _consultations[index] = consultation;
        notifyListeners();
      }
    } catch (e) {
      print('Error al actualizar consulta: $e');
    }
  }

  // Eliminar consulta
  Future<void> removeConsultation(int id) async {
    try {
      await _consultationService.deleteConsultation(id);
      _consultations.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print('Error al eliminar consulta: $e');
    }
  }

  void selectConsultation(Consultation consultation) {
    _selectedConsultation = consultation;
    notifyListeners();
  }

  void clearSelectedConsultation() {
    _selectedConsultation = null;
    notifyListeners();
  }
}