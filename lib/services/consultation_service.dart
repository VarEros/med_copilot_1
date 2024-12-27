import 'package:med_copilot_1/models/consultation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:med_copilot_1/services/auth_service.dart';

class ConsultationService {
  final AuthService _authService = AuthService();
  final String baseUrl = 'http://localhost:5000/consultations';
  String? token;
  int? user;

  // Obtener todas las consultas
  Future<List<Consultation>> fetchConsultations() async {    
    token = await _authService.getToken();
    user = await _authService.getUser();
    if (token == null) {
      throw Exception('No se encontró un token. Inicia sesión nuevamente.');
    }

    final response = await http.get(Uri.parse('$baseUrl/user/$user'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Consultation.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar consultas');
    }
  }

  // Obtener todas las consultas por pacientes
  Future<List<Consultation>> fetchConsultationsByPatient(int patientId) async {    
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('No se encontró un token. Inicia sesión nuevamente.');
    }

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
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('No se encontró un token. Inicia sesión nuevamente.');
    }

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
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('No se encontró un token. Inicia sesión nuevamente.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${consultation.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(consultation.toJson()),
    );

    if (response.statusCode == 404) {
      throw 'La consulta que desea modificar ya no esta disponible';
    }

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar consulta');
    }
  }

  // Eliminar una consulta
  Future<void> deleteConsultation(int id) async {    
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('No se encontró un token. Inicia sesión nuevamente.');
    }
    
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 404) {
      throw 'La consulta que desea eliminar ya no esta disponible';
    }

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar consulta');
    }
  }
}