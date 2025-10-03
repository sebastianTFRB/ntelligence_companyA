import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';
import '../models/users_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // animación splash

    final user = _auth.currentUser;
    if (user == null) {
      // No logueado → ir al login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      // Logueado → consultamos su rol en Firestore
      final doc =
          await _firestore.collection("users").doc(user.uid).get();

      if (doc.exists) {
        final currentUser =
            AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        _redirectUser(currentUser.role);
      } else {
        // Si no hay documento en Firestore → forzamos login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    }
  }

  void _redirectUser(String role) {
    switch (role) {
      case "admin":
        Navigator.pushReplacementNamed(context, "/admin_home");
        break;
      case "profesor":
        Navigator.pushReplacementNamed(context, "/profesor_home");
        break;
      case "estudiante":
      default:
        Navigator.pushReplacementNamed(context, "/estudiante_home");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (puedes poner una imagen en assets/logo.png)
            Icon(Icons.school, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Intelligence School",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
