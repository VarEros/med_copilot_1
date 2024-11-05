import 'package:med_copilot_1/models/consultation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConsultationService {
  final String baseUrl = 'http://192.168.1.11:5000/consultations';

  // Obtener todas las consultas
  Future<List<Consultation>> fetchConsultations() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Consultation.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar consultas');
    }
  }

  // Obtener todas las consultas por pacientes
  Future<List<Consultation>> fetchConsultationsByPatient(int patientId) async {
    final response = await http.get(Uri.parse('$baseUrl/patient/$patientId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Consultation.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar consultas');
    }
  }

  // Agregar una nueva consulta
  Future<void> createConsultation(Consultation consultation) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(consultation.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al agregar consulta');
    }
  }

  // Actualizar una consulta existente
  Future<void> updateConsultation(Consultation consultation) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${consultation.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(consultation.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar consulta');
    }
  }

  // Eliminar una consulta
  Future<void> deleteConsultation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar consulta');
    }
  }
}