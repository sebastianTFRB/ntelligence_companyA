import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgregarUsuarioWidget extends StatefulWidget {
  final FirebaseFirestore db;
  const AgregarUsuarioWidget({super.key, required this.db});

  @override
  State<AgregarUsuarioWidget> createState() => _AgregarUsuarioWidgetState();
}

class _AgregarUsuarioWidgetState extends State<AgregarUsuarioWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _docController = TextEditingController();
  String _roleSeleccionado = 'estudiante';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final nombre = _nombreController.text.trim();
      final email = _emailController.text.trim();
      final contrasena = _docController.text.trim().isEmpty
          ? email.split('@')[0]
          : _docController.text.trim();

      // 👉 1. Crear usuario en Firebase Authentication
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: contrasena,
      );

      // 👉 2. Preparar datos para Firestore
      final Map<String, dynamic> userData = {
        'uid': cred.user!.uid,
        'nombre': nombre,
        'email': email,
        'role': _roleSeleccionado,
      };

      // 👉 3. Guardar en Firestore (con uid como ID del documento)
      await widget.db.collection('users').doc(cred.user!.uid).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Usuario $_roleSeleccionado creado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      // 👉 4. Limpiar campos
      _nombreController.clear();
      _emailController.clear();
      _docController.clear();
      setState(() {
        _roleSeleccionado = 'estudiante';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al crear usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              "Registrar nuevo usuario",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Nombre completo
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre completo",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Ingresa un nombre";
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Correo electrónico
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Ingresa un correo";
                if (!value.contains("@")) return "Correo no válido";
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Documento / contraseña
            TextFormField(
              controller: _docController,
              decoration: const InputDecoration(
                labelText: "Documento de identidad (Contraseña)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge_outlined),
                hintText: "Si se deja vacío, será el nombre del correo",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Rol
            DropdownButtonFormField<String>(
              value: _roleSeleccionado,
              decoration: const InputDecoration(
                labelText: "Rol",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "estudiante", child: Text("Estudiante")),
                DropdownMenuItem(value: "profesor", child: Text("Profesor")),
              ],
              onChanged: (value) {
                setState(() {
                  _roleSeleccionado = value!;
                });
              },
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _crearUsuario,
              icon: const Icon(Icons.save),
              label: const Text("Guardar Usuario"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
