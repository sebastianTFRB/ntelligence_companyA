import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLogin = true; // alterna entre login y registro
  String? selectedRole;

  Future<void> _authenticate() async {
    try {
      if (isLogin) {
        // LOGIN
        UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        DocumentSnapshot doc = await _firestore.collection("users").doc(userCred.user!.uid).get();
        AppUser currentUser = AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        _redirectUser(currentUser.role);

      } else {
        // REGISTRO
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        AppUser newUser = AppUser(
          uid: userCred.user!.uid,
          email: _emailController.text.trim(),
          role: selectedRole ?? "estudiante",
        );

        await _firestore.collection("users").doc(newUser.uid).set(newUser.toMap());

        _redirectUser(newUser.role);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school, size: 80, color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text(
                    isLogin ? "Iniciar Sesión" : "Registro",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                  if (!isLogin) ...[
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Selecciona rol",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: selectedRole,
                      onChanged: (val) => setState(() => selectedRole = val),
                      items: ["admin", "profesor", "estudiante"].map((r) {
                        return DropdownMenuItem(value: r, child: Text(r));
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isLogin ? "Iniciar Sesión" : "Registrarse"),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? "¿No tienes cuenta? Regístrate"
                          : "¿Ya tienes cuenta? Inicia sesión",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
