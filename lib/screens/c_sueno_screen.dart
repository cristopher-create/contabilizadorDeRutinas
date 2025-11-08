// lib/screens/c_sueno_screen.dart
import 'package:flutter/material.dart';
import '../widgets/capture_history_widget.dart';

class CSuenoScreen extends StatefulWidget {
  const CSuenoScreen({super.key});

  @override
  _CSuenoScreenState createState() => _CSuenoScreenState();
}

class _CSuenoScreenState extends State<CSuenoScreen> {
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
        title: const Text('Contador de Sueño'),
      ),
      body: CaptureHistoryWidget(
        title: 'Contador de Sueño',
        history: _history,
        onCapture: _captureNow,
        icon: Icons.hotel,
        accentColor: Colors.indigo,
      ),
    );
  }
}