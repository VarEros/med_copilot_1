import 'package:med_copilot_1/models/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> saveUser(Credentials data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user', data.userId);
    await prefs.setString('jwt_token', data.accessToken);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<int?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
