import 'package:flutter/material.dart';
import 'package:pruebadatabase/screens/login_screen.dart'; // Importa tu pantalla de login
import 'package:pruebadatabase/services/auth_service.dart'; // Importa tu servicio de autenticación

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  final AuthService _authService = AuthService();

  // Método para manejar el cierre de sesión
  Future<void> _handleSignOut() async {
    try {
      await _authService.signOut(); // Llama al método signOut de tu servicio
      
      // Regresa al LoginScreen y elimina todas las rutas anteriores
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Esto borra el historial de navegación
      );
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      // Muestra un error si es necesario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        actions: [
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}