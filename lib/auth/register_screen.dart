import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelligence_company_ia/widgets/auth/dising/wave_background.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  String? _selectedGrado;
  String? _selectedGrupo;

  Future<void> _register() async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final newUser = {
        "uid": cred.user!.uid,
        "email": _emailController.text.trim(),
        "role": _selectedRole ?? "estudiante",
        if (_selectedRole == "estudiante") ...{
          "grado": _selectedGrado ?? "",
          "grupo": _selectedGrupo ?? "",
        }
      };

      await _firestore.collection("users").doc(cred.user!.uid).set(newUser);

      Navigator.pushReplacementNamed(context, "/login");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Usuario registrado correctamente")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const WaveBackground(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/auth/inicio.png', height: 120),
                    const SizedBox(height: 16),
                    const Text(
                      "Registro de Usuario",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF6A1B9A)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Documento de identidad (contraseña)",
                        prefixIcon: Icon(Icons.badge_outlined, color: Color(0xFF6A1B9A)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Selecciona rol",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val),
                      items: const [
                        DropdownMenuItem(value: "admin", child: Text("Admin")),
                        DropdownMenuItem(value: "profesor", child: Text("Profesor")),
                        DropdownMenuItem(value: "estudiante", child: Text("Estudiante")),
                      ],
                    ),
                    if (_selectedRole == "estudiante") ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Grado",
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedGrado,
                        onChanged: (val) => setState(() => _selectedGrado = val),
                        items: List.generate(
                          11,
                          (i) => DropdownMenuItem(
                            value: "${i + 1}",
                            child: Text("Grado ${i + 1}"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Grupo",
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedGrupo,
                        onChanged: (val) => setState(() => _selectedGrupo = val),
                        items: const [
                          DropdownMenuItem(value: "A", child: Text("A")),
                          DropdownMenuItem(value: "B", child: Text("B")),
                          DropdownMenuItem(value: "C", child: Text("C")),
                        ],
                      ),
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Registrarse"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      child: const Text(
                        "¿Ya tienes cuenta? Inicia sesión",
                        style: TextStyle(color: Color(0xFF6A1B9A)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
