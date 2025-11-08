// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  // ¡CAMBIA ESTA URL para que apunte a tu nuevo backend!
  // Si tu backend corre en el puerto 3000, será:
  final String _backendBaseUrl = 'https://flores57backend.onrender.com'; // ¡Pega la URL real de tu Render aquí!
  // Ahora tu Flutter app hablará con tu backend, no directamente con SQLite Cloud.

  // Estas variables ya no se usarán directamente desde Flutter para la llamada HTTP
  //final String _webliteBaseUrl = 'https://cawalewunz.g6.sqlite.cloud:443';
  //final String _sqlEndpoint = '/v2/weblite/sql';
  //final String _databaseName = 'RutaFlores57';
  //final String _apiKey = 'QJYxE87mjfLEtfZc4y5E8LCKT9cG9asShOBlPZpGbsc';

  Future<bool> login(String idInspector, String password) async {
    // La URL ahora apunta a tu endpoint de login en el backend
    final url = Uri.parse('$_backendBaseUrl/login');
    debugPrint('Intentando login enviando credenciales a mi backend en: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'idInspector': idInspector,
          'password': password,
        }),
      );

      debugPrint('Código de estado HTTP del Backend: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta del Backend: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] ?? false; // El backend te dirá si fue exitoso
      } else {
        // El backend devolvió un error (ej. 401 si las credenciales son malas)
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('Error del Backend: ${responseData['message'] ?? 'Error desconocido'}');
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión o procesamiento con el backend: $e');
      return false;
    }
  }
}