// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // <-- 1. ¡ASEGÚRATE DE QUE ESTE IMPORT ESTÉ ASÍ!
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Para debugPrint

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // <-- 2. AHORA ESTA LÍNEA FUNCIONARÁ
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Tu código de login con backend
  final String _backendBaseUrl = 'https://flores57backend.onrender.com';
  Future<bool> login(String idInspector, String password) async {
    // ... tu código de login con http ...
    debugPrint('Función de login backend llamada');
    return false; // Tu lógica aquí
  }

  // --- CÓDIGO CORREGIDO PARA GOOGLE SIGN-IN ---

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Disparar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 2. Si el usuario cancela
      if (googleUser == null) {
        debugPrint('Inicio de sesión cancelado por el usuario.');
        return null; 
      }

      // 3. Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Crear una credencial de Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Iniciar sesión en Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // 6. (Bonus) Guardar/Actualizar el usuario en Firestore
      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _db.collection('users').doc(user.uid).set({
            'displayName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
          debugPrint('Nuevo usuario creado en Firestore');
        } else {
          debugPrint('Usuario existente ha iniciado sesión');
        }
      }

      // 7. Devuelve el UserCredential completo
      return userCredential;

    } catch (e) {
      debugPrint("Error en Google Sign-In: $e");
      return null;
    }
  }

  // MÉTODO PARA CERRAR SESIÓN
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    debugPrint('Usuario cerró sesión');
  }
}