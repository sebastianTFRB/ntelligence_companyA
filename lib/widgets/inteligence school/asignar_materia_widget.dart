import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/users_model.dart';
import '../../../models/inteligenceshool/materia_model.dart';

class AsignarMateriaWidget extends StatefulWidget {
  final FirebaseFirestore db;
  const AsignarMateriaWidget({super.key, required this.db});

  @override
  State<AsignarMateriaWidget> createState() => _AsignarMateriaWidgetState();
}

class _AsignarMateriaWidgetState extends State<AsignarMateriaWidget> {
  String? _materiaSeleccionada;
  String? _estudianteSeleccionado;

  Future<List<Materia>> _obtenerMaterias() async {
    final snapshot = await widget.db.collection('materias').get();
    return snapshot.docs.map((d) => Materia.fromMap(d.data(), d.id)).toList();
  }

  Future<List<AppUser>> _obtenerEstudiantes() async {
    final snapshot = await widget.db
        .collection('users')
        .where('role', isEqualTo: 'estudiante')
        .get();
    return snapshot.docs.map((d) => AppUser.fromMap(d.data(), d.id)).toList();
  }

  Future<void> _asignarMateria() async {
    if (_materiaSeleccionada == null || _estudianteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona materia y estudiante.")),
      );
      return;
    }

    await widget.db.collection('asignaciones').add({
      'materiaId': _materiaSeleccionada,
      'estudianteId': _estudianteSeleccionado,
      'fechaAsignacion': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Materia asignada correctamente.")),
    );

    setState(() {
      _materiaSeleccionada = null;
      _estudianteSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: Future.wait([
          _obtenerMaterias(),
          _obtenerEstudiantes(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final materias = snapshot.data![0] as List<Materia>;
          final estudiantes = snapshot.data![1] as List<AppUser>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Selecciona una materia:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _materiaSeleccionada,
                hint: const Text("Materia"),
                isExpanded: true,
                items: materias
                    .map((m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(m.nombre),
                        ))
                    .toList(),
                onChanged: (val) => setState(() {
                  _materiaSeleccionada = val;
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                "Selecciona un estudiante:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _estudianteSeleccionado,
                hint: const Text("Estudiante"),
                isExpanded: true,
                items: estudiantes
                    .map((e) => DropdownMenuItem(
                          value: e.uid,
                          child: Text(e.email),
                        ))
                    .toList(),
                onChanged: (val) => setState(() {
                  _estudianteSeleccionado = val;
                }),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _asignarMateria,
                icon: const Icon(Icons.add_task),
                label: const Text("Asignar Materia"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
