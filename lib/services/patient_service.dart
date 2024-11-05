import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:med_copilot_1/models/patient.dart';

class PatientService {
  final String baseUrl = 'http://192.168.1.11:5000/patients';

  // Obtener todos los pacientes
  Future<List<Patient>> fetchPatients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar pacientes');
    }
  }

  // Agregar un nuevo paciente
  Future<void> createPatient(Patient patient) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(patient.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al agregar paciente');
    }
  }

  // Actualizar un paciente existente
  Future<void> updatePatient(Patient patient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${patient.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(patient.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar paciente');
    }
  }

  // Eliminar un paciente
  Future<void> deletePatient(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar paciente');
    }
  }
}