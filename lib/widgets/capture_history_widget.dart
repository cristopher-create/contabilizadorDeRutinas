// lib/widgets/capture_history_widget.dart
import 'package:flutter/material.dart';

typedef DateTimeFormatter = String Function(DateTime dt);

class CaptureHistoryWidget extends StatelessWidget {
  final String title;
  final List<DateTime> history;
  final VoidCallback onCapture;
  final IconData icon;
  final Color? accentColor;
  final DateTimeFormatter? formatter;

  const CaptureHistoryWidget({
    super.key,
    required this.title,
    required this.history,
    required this.onCapture,
    this.icon = Icons.access_time,
    this.accentColor,
    this.formatter,
  });

  String _defaultFormat(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    final day = two(dt.day);
    final month = two(dt.month);
    final year = dt.year.toString();
    final hour = two(dt.hour);
    final minute = two(dt.minute);
    final second = two(dt.second);
    return '$day/$month/$year $hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final hasHistory = history.isNotEmpty;
    final last = hasHistory ? history.first : null;
    final color = accentColor ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onCapture,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Capturar hora', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 18),
          if (hasHistory) ...[
            Card(
              color: color.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(icon, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Última captura', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            (formatter ?? _defaultFormat)(last!),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Historial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
          ] else ...[
            const SizedBox(height: 12),
            const Text(
              'Aún no hay capturas. Pulsa "Capturar hora" para añadir la primera entrada.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
          ],
          Expanded(
            child: history.isEmpty
                ? const SizedBox()
                : ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final dt = history[index];
                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text((formatter ?? _defaultFormat)(dt)),
                        subtitle: Text('Registro #${history.length - index}'),
                        dense: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}