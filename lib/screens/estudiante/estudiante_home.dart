import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/users_model.dart';
import '../../../models/inteligenceshool/materia_model.dart';
import '../../../widgets/inteligence school/materia_card.dart';

class EstudianteHome extends StatelessWidget {
  final AppUser user;

  const EstudianteHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido, ${user.email.split('@').first}"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _db
            .collection('asignaciones_estudiantes')
            .where('estudianteId', isEqualTo: user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final asignacionesEst = snapshot.data?.docs ?? [];
          if (asignacionesEst.isEmpty) {
            return const Center(
              child: Text(
                "No estás asignado a ningún grupo aún.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Obtenemos todos los grupos del estudiante
          final grupoIds = asignacionesEst
              .map((doc) => doc['grupoId'] as String)
              .toSet()
              .toList();

          // Ahora obtenemos todas las materias asignadas a esos grupos
          return FutureBuilder<QuerySnapshot>(
            future: _db
                .collection('asignaciones_profesores')
                .where('grupoId', whereIn: grupoIds)
                .get(),
            builder: (context, materiasSnap) {
              if (materiasSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (materiasSnap.hasError) {
                return Center(child: Text("Error: ${materiasSnap.error}"));
              }

              final asignacionesProfes = materiasSnap.data?.docs ?? [];
              if (asignacionesProfes.isEmpty) {
                return const Center(
                  child: Text(
                    "No hay materias asignadas a tu grupo aún.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              // Obtenemos los IDs de materias
              final materiaIds = asignacionesProfes
                  .map((doc) => doc['materiaId'] as String)
                  .toSet()
                  .toList();

              // Finalmente obtenemos los documentos de materias
              return FutureBuilder<QuerySnapshot>(
                future: _db
                    .collection('materias')
                    .where(FieldPath.documentId, whereIn: materiaIds)
                    .get(),
                builder: (context, materiasDocsSnap) {
                  if (materiasDocsSnap.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (materiasDocsSnap.hasError) {
                    return Center(
                        child: Text("Error: ${materiasDocsSnap.error}"));
                  }

                  final materiasDocs = materiasDocsSnap.data?.docs ?? [];
                  final materias = materiasDocs
                      .map((d) =>
                          Materia.fromMap(d.data() as Map<String, dynamic>, d.id))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: materias.length,
                    itemBuilder: (context, index) =>
                        MateriaCard(materia: materias[index]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
