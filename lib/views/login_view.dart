import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:med_copilot_1/main.dart';
import 'package:med_copilot_1/models/user.dart';
import 'package:med_copilot_1/viewmodels/user_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({ super.key });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late User user;
  final UserViewModel userViewModel = UserViewModel();
  
  Future<String?> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    final user = User(email: data.name, password: data.password);
    String? isUserValid = await userViewModel.authUser(user);
    return isUserValid;
  }

  Future<String?> _signUp(SignupData data) async {
    final user = User(email: data.name!, password: data.password!);
    String? userCreated = await userViewModel.createUser(user);
    return userCreated;
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(const Duration(milliseconds: 3000), () {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/logo.png'),
      title: 'Med Copilot',
      userType: LoginUserType.email,
      onLogin: _authUser,
      onSignup: _signUp,
      loginAfterSignUp: false,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      },
      userValidator: defaultEmailValidator,
      passwordValidator: defaultPasswordValidator,
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        userHint: 'Usuario',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'INICIAR SESIÓN',
        signupButton: 'REGISTRARSE',
        forgotPasswordButton: '¿Olvidaste tu contraseña?',
        recoverPasswordButton: 'AYÚDAME',
        goBackButton: 'REGRESAR',
        confirmPasswordError: 'No coincide!',
        recoverPasswordDescription: 'Enviaremos tu contraseña a esta dirección de correo electronico.',
        recoverPasswordIntro: 'Recupera tu contraseña'
      ),
      
    );
  }
  
  static String? defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return 'Correo inválido.';
    }
    return null;
  }

  static String? defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty || value.length <= 2) {
      return 'La contraseña es muy corta.';
    }
    return null;
  }
}
