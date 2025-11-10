// lib/services/auth_service.dart

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

// ¡¡IMPORTANTE!! DEBES IMPORTAR ESTO:
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Asumo que también usarás Firebase Auth


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Tu código de login con backend (¡esto está bien!)
  final String _backendBaseUrl = 'https://flores57backend.onrender.com';
  Future<bool> login(String idInspector, String password) async {
     // ... tu código de login con http ...
     return false; // Tu lógica aquí
  }


  // --- NUEVO CÓDIGO PARA GOOGLE SIGN-IN ---

  // Futuro que se completa cuando init() se ha llamado
  Future<void>? _initialization;

  // Función para asegurar que Google Sign-In esté inicializado
  Future<void> _ensureInitialized() {
    return _initialization ??= GoogleSignInPlatform.instance.init(
      const InitParameters(),
    )..catchError((dynamic _) {
      _initialization = null;
    });
  }


  // 1. MÉTODO PARA INICIAR SESIÓN CON GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Asegura que esté inicializado
      await _ensureInitialized();

      // 1. Inicia el flujo de autenticación de Google (reemplaza a .signIn())
      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());

      final GoogleSignInUserData googleUser = result.user;

      // Si el usuario cancela
      if (googleUser == null) {
        debugPrint('Inicio de sesión de Google cancelado.');
        return null;
      }
      
      // 2. Obtén los tokens
      final ClientAuthorizationTokenData? tokens = await GoogleSignInPlatform
          .instance
          .clientAuthorizationTokensForScopes(
            ClientAuthorizationTokensForScopesParameters(
              request: AuthorizationRequestDetails(
                scopes: ['email', 'profile'], // Pide los scopes que necesites
                userId: googleUser.id,
                email: googleUser.email,
                promptIfUnauthorized: false,
              ),
            ),
          );

      if (tokens == null) {
        debugPrint('No se pudieron obtener los tokens de Google.');
        return null;
      }

      // 3. Crea la credencial de Firebase con el token (reemplaza tu error 3)
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: tokens.idToken,           // ¡Usa el idToken para Firebase!
        accessToken: tokens.accessToken, // Y/o el accessToken
      );

      // 4. Inicia sesión en Firebase con esa credencial
      return await _firebaseAuth.signInWithCredential(credential);

    } on GoogleSignInException catch (e) {
      debugPrint('Error de GoogleSignInException ${e.code}: ${e.description}');
      return null;
    } catch (e) {
      debugPrint('Error inesperado en signInWithGoogle: $e');
      return null;
    }
  }

  // MÉTODO PARA CERRAR SESIÓN
  Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignInPlatform.instance.disconnect(const DisconnectParams());
    await _firebaseAuth.signOut();
  }
}