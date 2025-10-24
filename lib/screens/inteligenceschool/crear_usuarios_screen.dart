import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/users_model.dart';

class CrearUsuariosScreen extends StatefulWidget {
  const CrearUsuariosScreen({super.key});

  @override
  State<CrearUsuariosScreen> createState() => _CrearUsuariosScreenState();
}

class _CrearUsuariosScreenState extends State<CrearUsuariosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  String _selectedRole = 'estudiante';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newUser = AppUser(
        uid: _uidController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole, 
        nombre: '',
      );

      await _db.collection('usuarios').doc(newUser.uid).set(newUser.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado exitosamente')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedRole = 'estudiante';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Estudiantes / Profesores'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Registro de Usuario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _uidController,
                decoration: const InputDecoration(
                  labelText: 'UID del usuario (Firebase Auth)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un UID válido' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un correo válido' : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rol del usuario',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'estudiante', child: Text('Estudiante')),
                  DropdownMenuItem(value: 'profesor', child: Text('Profesor')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _crearUsuario,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Usuario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
