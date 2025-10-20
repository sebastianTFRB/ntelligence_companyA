import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelligence_company_ia/widgets/project_selector_appbar.dart';

class DetalleGrupoScreen extends StatefulWidget {
  final String grupoId;
  final String nombreGrupo;

  const DetalleGrupoScreen({
    super.key,
    required this.grupoId,
    required this.nombreGrupo,
  });

  @override
  State<DetalleGrupoScreen> createState() => _DetalleGrupoScreenState();
}

class _DetalleGrupoScreenState extends State<DetalleGrupoScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Color primaryColor = const Color.fromARGB(255, 162, 29, 211);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: ProjectSelectorAppBar(
        title: "IntelligenceSchool",
        backgroundColor: primaryColor,
        customTitle: Image.asset(
          'assets/logos/logo_C.png',
          height: 250,
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("👨‍🎓 Estudiantes asignados"),
                  const SizedBox(height: 10),
                  _buildEstudiantesList(),
                  const SizedBox(height: 30),
                  _buildSectionTitle("📚 Materias y profesores"),
                  const SizedBox(height: 10),
                  _buildMateriasList(),
                  const SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "⟵ Retroceder",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Header decorativo superior
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('asignaciones_estudiantes')
            .where('grupoId', isEqualTo: widget.grupoId)
            .snapshots(),
        builder: (context, snapshot) {
          final count = snapshot.data?.docs.length ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Grupo ${widget.nombreGrupo}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Estudiantes: $count",
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔹 Título de sección
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  // 🔹 Lista de estudiantes
  Widget _buildEstudiantesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('asignaciones_estudiantes')
          .where('grupoId', isEqualTo: widget.grupoId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final estudiantes = snapshot.data!.docs;

        if (estudiantes.isEmpty) {
          return _emptyMessage("No hay estudiantes asignados aún.");
        }

        return Column(
          children: estudiantes.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final estudianteId = data['estudianteId'];

            return FutureBuilder<DocumentSnapshot>(
              future: _db.collection('users').doc(estudianteId).get(),
              builder: (context, userSnap) {
                if (!userSnap.hasData) {
                  return const ListTile(title: Text("Cargando estudiante..."));
                }

                final userData = userSnap.data!.data() as Map<String, dynamic>?;
                final nombre = userData?['nombre'] ?? 'Sin nombre';
                final email = userData?['email'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Text(
                        nombre.isNotEmpty ? nombre[0].toUpperCase() : "?",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    subtitle:
                        Text(email.isNotEmpty ? email : "ID: $estudianteId"),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 16, color: primaryColor.withOpacity(0.4)),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  // 🔹 Lista de materias
  Widget _buildMateriasList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('asignaciones_profesores')
          .where('grupoId', isEqualTo: widget.grupoId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final asignaciones = snapshot.data!.docs;

        if (asignaciones.isEmpty) {
          return _emptyMessage("No hay materias asignadas a este grupo.");
        }

        return Column(
          children: asignaciones.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final profesorId = data['profesorId'];
            final materiaId = data['materiaId'];

            return FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait([
                _db.collection('users').doc(profesorId).get(),
                _db.collection('materias').doc(materiaId).get(),
              ]),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const ListTile(title: Text("Cargando materia..."));
                }

                final profesorData = snap.data![0].data() as Map<String, dynamic>?;
                final materiaData = snap.data![1].data() as Map<String, dynamic>?;

                final profesorNombre = profesorData?['nombre'] ?? 'Desconocido';
                final materiaNombre = materiaData?['nombre'] ?? 'Sin nombre';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.12),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.book, color: Colors.white),
                    ),
                    title: Text(materiaNombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    subtitle: Text("Profesor: $profesorNombre",
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  // 🔹 Mensaje vacío
  Widget _emptyMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
