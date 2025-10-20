import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/users_model.dart';

class AsignarEstudianteWidget extends StatefulWidget {
  final FirebaseFirestore db;
  const AsignarEstudianteWidget({super.key, required this.db});

  @override
  State<AsignarEstudianteWidget> createState() => _AsignarEstudianteWidgetState();
}

class _AsignarEstudianteWidgetState extends State<AsignarEstudianteWidget> {
  String? _estudianteSeleccionado;
  String? _grupoSeleccionado;

  Future<List<AppUser>> _obtenerEstudiantes() async {
    final snapshot = await widget.db
        .collection('users')
        .where('role', isEqualTo: 'estudiante')
        .get();
    return snapshot.docs.map((d) => AppUser.fromMap(d.data(), d.id)).toList();
  }

  Future<void> _asignarGrupo() async {
    if (_estudianteSeleccionado == null || _grupoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos.")),
      );
      return;
    }

    final grupoDoc =
        await widget.db.collection('grupos').doc(_grupoSeleccionado).get();
    final data = grupoDoc.data();

    if (data == null) return;

    await widget.db.collection('asignaciones_estudiantes').add({
      'estudianteId': _estudianteSeleccionado,
      'grupoId': _grupoSeleccionado,
      'grado': data['grado'],
      'letra': data['letra'],
      'fecha': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Estudiante asignado correctamente.")),
    );

    setState(() {
      _estudianteSeleccionado = null;
      _grupoSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _obtenerEstudiantes(),
      builder: (context, snapshotEstudiantes) {
        if (!snapshotEstudiantes.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final estudiantes = snapshotEstudiantes.data as List<AppUser>;

        return StreamBuilder<QuerySnapshot>(
          stream: widget.db.collection('grupos').orderBy('grado').snapshots(),
          builder: (context, snapshotGrupos) {
            if (!snapshotGrupos.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final grupos = snapshotGrupos.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Asignar grupo a estudiante",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Dropdown Estudiante
                  DropdownButtonFormField<String>(
                    value: _estudianteSeleccionado,
                    hint: const Text("Seleccionar estudiante"),
                    items: estudiantes
                        .map((e) => DropdownMenuItem(
                              value: e.uid,
                              child: Text(e.email),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _estudianteSeleccionado = v),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Dropdown Grupo (desde Firestore)
                  DropdownButtonFormField<String>(
                    value: _grupoSeleccionado,
                    hint: const Text("Seleccionar grupo"),
                    items: grupos.map((g) {
                      final data = g.data() as Map<String, dynamic>;
                      final nombreGrupo =
                          "Grado ${data['grado']}${data['letra']}";
                      return DropdownMenuItem(
                        value: g.id,
                        child: Text(nombreGrupo),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _grupoSeleccionado = v),
                  ),

                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _asignarGrupo,
                    icon: const Icon(Icons.add),
                    label: const Text("Asignar Grupo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
