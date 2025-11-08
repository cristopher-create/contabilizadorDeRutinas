// lib/screens/c_fab_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/capture_history_widget.dart';

class CFabScreen extends StatefulWidget {
  const CFabScreen({super.key});

  @override
  _CFabScreenState createState() => _CFabScreenState();
}

class _CFabScreenState extends State<CFabScreen> {
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
        title: const Text('Contador de FAB'),
      ),
      body: CaptureHistoryWidget(
        title: 'Contador de FAB',
        history: _history,
        onCapture: _captureNow,
        icon: Icons.fiber_manual_record,
        accentColor: Colors.blueAccent,
      ),
    );
  }
}