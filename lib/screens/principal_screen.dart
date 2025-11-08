// lib/screens/principal_screen.dart
import 'package:flutter/material.dart';
import 'c_fab_screen.dart';
import 'c_ejercicio_screen.dart';
import 'c_sueno_screen.dart';
import 'settings_screen.dart';

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicación de Actividades'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ajustes',
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Registro de Actividad Cotidiana',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _openScreen(context, const CFabScreen()),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Contador de FAB', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _openScreen(context, const CEjercicioScreen()),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Contador de Ejercicio', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _openScreen(context, const CSuenoScreen()),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Contador de Sueño', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}