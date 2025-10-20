import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/users_model.dart';
import '../../../models/inteligenceshool/materia_model.dart';
import '../../../models/inteligenceshool/grupo_model.dart';

class AsignarProfesorWidget extends StatefulWidget {
  final FirebaseFirestore db;
  const AsignarProfesorWidget({super.key, required this.db});

  @override
  State<AsignarProfesorWidget> createState() => _AsignarProfesorWidgetState();
}

class _AsignarProfesorWidgetState extends State<AsignarProfesorWidget> {
  String? _profesorSeleccionado;
  String? _materiaSeleccionada;
  String? _grupoSeleccionado;

  // 🔹 Obtener profesores (usuarios con rol profesor)
  Future<List<AppUser>> _obtenerProfesores() async {
    final snapshot = await widget.db
        .collection('users')
        .where('role', isEqualTo: 'profesor')
        .get();
    return snapshot.docs.map((d) => AppUser.fromMap(d.data(), d.id)).toList();
  }

  // 🔹 Obtener materias
  Future<List<Materia>> _obtenerMaterias() async {
    final snapshot = await widget.db.collection('materias').get();
    return snapshot.docs.map((d) => Materia.fromMap(d.data(), d.id)).toList();
  }

  // 🔹 Obtener grupos reales desde Firestore
  Future<List<Grupo>> _obtenerGrupos() async {
    final snapshot = await widget.db.collection('grupos').orderBy('grado').get();
    return snapshot.docs.map((d) => Grupo.fromMap(d.data(), d.id)).toList();
  }

  // 🔹 Asignar profesor
  Future<void> _asignarProfesor() async {
    if (_profesorSeleccionado == null ||
        _materiaSeleccionada == null ||
        _grupoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos.")),
      );
      return;
    }

    await widget.db.collection('asignaciones_profesores').add({
      'profesorId': _profesorSeleccionado,
      'materiaId': _materiaSeleccionada,
      'grupoId': _grupoSeleccionado,
      'fechaAsignacion': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Profesor asignado correctamente.")),
    );

    setState(() {
      _profesorSeleccionado = null;
      _materiaSeleccionada = null;
      _grupoSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _obtenerProfesores(),
        _obtenerMaterias(),
        _obtenerGrupos(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final profesores = snapshot.data![0] as List<AppUser>;
        final materias = snapshot.data![1] as List<Materia>;
        final grupos = snapshot.data![2] as List<Grupo>;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Asignar materia y grupo a profesor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 🔹 Profesor
              DropdownButtonFormField<String>(
                value: _profesorSeleccionado,
                hint: const Text("Seleccionar profesor"),
                items: profesores
                    .map((p) => DropdownMenuItem(value: p.uid, child: Text(p.email)))
                    .toList(),
                onChanged: (v) => setState(() => _profesorSeleccionado = v),
              ),
              const SizedBox(height: 20),

              // 🔹 Materia
              DropdownButtonFormField<String>(
                value: _materiaSeleccionada,
                hint: const Text("Seleccionar materia"),
                items: materias
                    .map((m) => DropdownMenuItem(value: m.id, child: Text(m.nombre)))
                    .toList(),
                onChanged: (v) => setState(() => _materiaSeleccionada = v),
              ),
              const SizedBox(height: 20),

              // 🔹 Grupo (basado en Firestore)
              DropdownButtonFormField<String>(
                value: _grupoSeleccionado,
                hint: const Text("Seleccionar grupo"),
                items: grupos
                    .map((g) => DropdownMenuItem(
                        value: g.id, child: Text("Grado ${g.grado}${g.letra}")))
                    .toList(),
                onChanged: (v) => setState(() => _grupoSeleccionado = v),
              ),

              const Spacer(),

              // 🔹 Botón Asignar
              ElevatedButton.icon(
                onPressed: _asignarProfesor,
                icon: const Icon(Icons.add_task),
                label: const Text("Asignar Profesor"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
