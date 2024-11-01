import 'package:med_copilot_1/models/patient.dart';

class Consultation {
  int id;
  String description;
  DateTime? registrationDate;
  Patient patient;

  Consultation({
    required this.id,
    required this.description,
    this.registrationDate,
    required this.patient,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'],
      description: json['description'],
      registrationDate: DateTime.parse(json['registration_date']),
      patient: Patient.fromJson(json['patient']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'patient_id': patient.id,
    };
  }
}