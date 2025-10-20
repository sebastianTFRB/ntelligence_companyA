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
  final _emailController = TextEditingController();
  final _docController = TextEditingController();
  final _gradoController = TextEditingController();
  String _grupoSeleccionado = 'A';
  String _roleSeleccionado = 'estudiante';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    try {
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
        'email': email,
        'role': _roleSeleccionado,
      };

      if (_roleSeleccionado == 'estudiante') {
        userData['grado'] = _gradoController.text.trim();
        userData['grupo'] = _grupoSeleccionado;
      }

      // 👉 3. Guardar en Firestore (con uid como ID del documento)
      await widget.db.collection('users').doc(cred.user!.uid).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Usuario $_roleSeleccionado creado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      // 👉 4. Limpiar campos
      _emailController.clear();
      _docController.clear();
      _gradoController.clear();
      setState(() {
        _roleSeleccionado = 'estudiante';
        _grupoSeleccionado = 'A';
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
            const SizedBox(height: 20),

            if (_roleSeleccionado == 'estudiante') ...[
              TextFormField(
                controller: _gradoController,
                decoration: const InputDecoration(
                  labelText: "Grado",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (_roleSeleccionado == 'estudiante' &&
                      (value == null || value.isEmpty)) {
                    return "Ingresa el grado";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _grupoSeleccionado,
                decoration: const InputDecoration(
                  labelText: "Grupo",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "A", child: Text("A")),
                  DropdownMenuItem(value: "B", child: Text("B")),
                  DropdownMenuItem(value: "C", child: Text("C")),
                ],
                onChanged: (value) {
                  setState(() {
                    _grupoSeleccionado = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

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
