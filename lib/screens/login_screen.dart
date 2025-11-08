import 'package:flutter/material.dart';
import 'principal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _navigateToPrincipalScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PrincipalScreen()),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contacto de Administración'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('Para solicitar una cuenta, por favor contacta al administrador.'),
              SizedBox(height: 10),
              Text('Teléfono: +123 456 7890'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _attemptLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    // Simular latencia (reemplazar cuando integres API real)
    await Future.delayed(const Duration(milliseconds: 700));

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Credenciales fijas para pruebas
    if (username == 'prueba' && password == '1234') {
      if (!mounted) return;
      _navigateToPrincipalScreen();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingresa el usuario';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Ingresa la contraseña';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_isLoading) _attemptLogin();
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _attemptLogin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Iniciar Sesión'),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _showContactDialog(context);
                  },
                  child: const Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}