// lib/screens/c_ejercicio_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/capture_history_widget.dart';

class CEjercicioScreen extends StatefulWidget {
  const CEjercicioScreen({super.key});

  @override
  _CEjercicioScreenState createState() => _CEjercicioScreenState();
}

class _CEjercicioScreenState extends State<CEjercicioScreen> {
  final List<DateTime> _history = [];

  void _captureNow() {
    final now = DateTime.now();
    setState(() {
      _history.insert(0, now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Ejercicio'),
      ),
      body: CaptureHistoryWidget(
        title: 'Contador de Ejercicio',
        history: _history,
        onCapture: _captureNow,
        icon: Icons.fitness_center,
        accentColor: Colors.green,
      ),
    );
  }
}