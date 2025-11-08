// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _saveToCloud = true;

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas cerrar la sesión y volver al login?'),
        actions: [
          TextButton(onPressed: null, child: Text('Cancelar')), // se cierra por defecto
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Cerrar sesión')),
        ],
      ),
    );

    if (confirm == true) {
      // Aquí puedes limpiar tokens / sesión antes de navegar
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _confirmClearHistory(String title, VoidCallback onClear) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar historial de $title'),
        content: const Text('Esta acción eliminará el historial local. ¿Continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      onClear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Historial de $title eliminado')),
      );
    }
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Aplicación de Actividades',
      applicationVersion: '1.0.0',
      children: const [
        Text('Registro sencillo de capturas de hora para FAB, ejercicio y sueño.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Preferencias', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Alternar tema oscuro (local, requiere implementación global)'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          SwitchListTile(
            title: const Text('Guardar en la nube'),
            subtitle: const Text('Enviar capturas automáticamente a tu base de datos en la nube'),
            value: _saveToCloud,
            onChanged: (v) => setState(() => _saveToCloud = v),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Privacidad y datos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar historial FAB'),
            onTap: () => _confirmClearHistory('FAB', () {
              // Implementa la limpieza real: llamar al servicio o Provider que maneje el historial
            }),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar historial Ejercicio'),
            onTap: () => _confirmClearHistory('Ejercicio', () {
              // Implementa la limpieza real
            }),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar historial Sueño'),
            onTap: () => _confirmClearHistory('Sueño', () {
              // Implementa la limpieza real
            }),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de'),
            onTap: _showAbout,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: _confirmLogout,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Ejemplo: aplicar cambios locales (tema, sync) — reemplaza con lógica real
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preferencias guardadas (simulación)')),
              );
            },
            child: const Text('Guardar preferencias'),
          ),
        ],
      ),
    );
  }
}