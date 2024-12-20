import 'package:flutter/material.dart';
import 'package:med_copilot_1/models/user.dart';
import 'package:med_copilot_1/services/user_service.dart';
import 'package:med_copilot_1/utils.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final SnackbarManager _snackbarManager = SnackbarManager('Paciente');

  UserViewModel();

  Future<String?> createUser(User user) async {
    try {
      await _userService.createUser(user);
      _snackbarManager.successSnackbar('Guardado');
      notifyListeners();
      return null;
    } catch (e) {
      print('Error al agregar usuario: $e');
      return e.toString();
    }
  }

  Future<String?> authUser(User user) async {
    try {
      await _userService.authUser(user);
      _snackbarManager.successSnackbar('Autenticado');
      notifyListeners();
      return null;
    } catch (e) {
      print('Error al autenticar usuario: $e');
      return e.toString();
    }
  }
}