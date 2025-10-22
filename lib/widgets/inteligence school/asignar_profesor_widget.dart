import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/users_model.dart';
import '../../../models/inteligenceshool/grupo_model.dart';

class AsignarProfesorWidget extends StatefulWidget {
  final FirebaseFirestore db;
  const AsignarProfesorWidget({super.key, required this.db});

  @override
  State<AsignarProfesorWidget> createState() => _AsignarProfesorWidgetState();
}

class _AsignarProfesorWidgetState extends State<AsignarProfesorWidget> {
  String? _profesorSeleccionado;
  String? _materiaGenericaSeleccionada;
  String? _grupoSeleccionado;

  // 🔹 Obtener profesores
  Future<List<AppUser>> _obtenerProfesores() async {
    final snapshot = await widget.db
        .collection('users')
        .where('role', isEqualTo: 'profesor')
        .get();
    return snapshot.docs
        .map((d) => AppUser.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  // 🔹 Obtener materias genéricas (devuelve lista de mapas con id incluido)
  Future<List<Map<String, dynamic>>> _obtenerMateriasGenericas() async {
    final snapshot = await widget.db.collection('materias_genericas').get();
    return snapshot.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data() as Map);
      data['id'] = d.id;
      return data;
    }).toList();
  }

  // 🔹 Obtener grupos
  Future<List<Grupo>> _obtenerGrupos() async {
    final snapshot = await widget.db.collection('grupos').orderBy('grado').get();
    return snapshot.docs.map((d) => Grupo.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
  }

  // 🔹 Asignar profesor: crea una materia específica basada en la genérica
  Future<void> _asignarProfesor() async {
    if (_profesorSeleccionado == null ||
        _materiaGenericaSeleccionada == null ||
        _grupoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos.")),
      );
      return;
    }

    // obtener docs
    final profesorSnap =
        await widget.db.collection('users').doc(_profesorSeleccionado).get();
    final materiaGenSnap = await widget.db
        .collection('materias_genericas')
        .doc(_materiaGenericaSeleccionada)
        .get();
    final grupoSnap = await widget.db.collection('grupos').doc(_grupoSeleccionado).get();

    final profesorData = profesorSnap.data() as Map<String, dynamic>? ?? {};
    final materiaGenData = materiaGenSnap.data() as Map<String, dynamic>? ?? {};
    final grupoData = grupoSnap.data() as Map<String, dynamic>? ?? {};

    // crear nueva materia específica en la colección 'materias'
    await widget.db.collection('materias').add({
      'nombre': materiaGenData['nombre'] ?? '',
      'descripcion': materiaGenData['descripcion'] ?? '',
      'materiaGenericaId': materiaGenSnap.id,
      'profesorId': profesorSnap.id,
      'profesorNombre': profesorData['nombre'] ?? profesorData['email'] ?? '',
      'grupoId': grupoSnap.id,
      'grupoNombre': "Grado ${grupoData['grado'] ?? ''}${grupoData['letra'] ?? ''}",
      'creado': FieldValue.serverTimestamp(),
    });

    // además guardamos la asignación (opcional, puedes omitir si no la necesitas)
    await widget.db.collection('asignaciones_profesores').add({
      'profesorId': profesorSnap.id,
      'materiaId': null, // si quieres enlazar con la materia creada, necesitas usar el ID resultante del add() anterior
      'materiaGenericaId': materiaGenSnap.id,
      'grupoId': grupoSnap.id,
      'fechaAsignacion': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Profesor asignado correctamente.")),
    );

    setState(() {
      _profesorSeleccionado = null;
      _materiaGenericaSeleccionada = null;
      _grupoSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _obtenerProfesores(),
        _obtenerMateriasGenericas(),
        _obtenerGrupos(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final profesores = snapshot.data![0] as List<AppUser>;
        final materiasGenericas = snapshot.data![1] as List<Map<String, dynamic>>;
        final grupos = snapshot.data![2] as List<Grupo>;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Asignar Profesor a Materia y Grupo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Profesor
              DropdownButtonFormField<String>(
                value: _profesorSeleccionado,
                hint: const Text("Seleccionar profesor"),
                items: profesores
                    .map((p) => DropdownMenuItem<String>(
                          value: p.uid,
                          child: Text(p.email),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _profesorSeleccionado = v),
              ),
              const SizedBox(height: 20),

              // Materia genérica (cast del id a String)
              DropdownButtonFormField<String>(
                value: _materiaGenericaSeleccionada,
                hint: const Text("Seleccionar materia genérica"),
                items: materiasGenericas
                    .map((m) => DropdownMenuItem<String>(
                          value: (m['id'] as String),
                          child: Text((m['nombre'] as String?) ?? ''),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _materiaGenericaSeleccionada = v),
              ),
              const SizedBox(height: 20),

              // Grupo (id string)
              DropdownButtonFormField<String>(
                value: _grupoSeleccionado,
                hint: const Text("Seleccionar grupo"),
                items: grupos
                    .map((g) => DropdownMenuItem<String>(
                          value: g.id,
                          child: Text("Grado ${g.grado}${g.letra}"),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _grupoSeleccionado = v),
              ),

              const Spacer(),

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
