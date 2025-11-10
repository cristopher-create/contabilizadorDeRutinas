 // Este es tu archivo lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importa tu servicio de auth
import '../services/auth_service.dart'; 
// Importa la pantalla principal (crea este archivo, p.ej. home_screen.dart)
// import 'home_screen.dart'; 
import 'principal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
  // 1. Obtén el "paquete" de credenciales
  UserCredential? userCredential = await _authService.signInWithGoogle();

  // 2. Comprueba si el inicio de sesión no fue cancelado
  if (userCredential != null) {
    
    // 3. ¡Ahora sí, obtén el usuario de dentro del paquete!
    User? user = userCredential.user;

    // (Opcional) Puedes verificar si el usuario es nulo (aunque es raro si userCredential no lo es)
    if (user != null) {
      debugPrint('Inicio de sesión exitoso: ${user.displayName}');
      
      // Navega a tu pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PrincipalScreen()), // O como se llame tu pantalla
      );
    }
  } else {
    // El usuario canceló el inicio de sesión (cerró la ventana de Google)
    debugPrint('Inicio de sesión cancelado por el usuario.');
  }

} catch (e) {
  // Manejar cualquier otro error
  debugPrint('Error durante el inicio de sesión: $e');
  // Mostrar un Snackbar o alerta
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fondo con gradiente sutil, estilo moderno
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A2FF), Color(0xFF007BFF)], // Tonos azules
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Logo/Nombre de la App (arriba)
              const Spacer(flex: 2),
              Text(
                'MiEspejo', // O el nombre que elijas, como "Lúcido"
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'TuFuentePersonalizada', // Opcional
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Toma el control de tus hábitos',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const Spacer(flex: 3),

              // 2. Botón de Login (centro)
              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : _buildGoogleSignInButton(),
              
              // 3. Términos y Condiciones (abajo)
              const Spacer(flex: 2),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para el botón personalizado de Google
  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/images/google_logo.png', // Asegúrate de tener esta imagen
        height: 24.0,
      ),
      label: const Text(
        'Continuar con Google',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Fondo blanco
        foregroundColor: Colors.black, // Color de "splash"
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 2,
      ),
      onPressed: _handleGoogleSignIn,
    );
  }
}