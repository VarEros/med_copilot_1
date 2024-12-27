import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:med_copilot_1/models/credentials.dart';
import 'package:med_copilot_1/models/user.dart';

class UserService {
  final userUrl = 'http://localhost:5000/users';
  final authUrl = 'http://localhost:5000/auth';

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(userUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw json.decode(response.body)['message'];
    }
  }

  Future<Credentials> authUser(User user) async {
    final response = await http.post(
      Uri.parse(authUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw json.decode(response.body)['message'];
    }

    final Map<String, dynamic> data = json.decode(response.body);
    return Credentials.fromJson(data);
  }
}