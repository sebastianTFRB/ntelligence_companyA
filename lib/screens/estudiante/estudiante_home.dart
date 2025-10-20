import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/users_model.dart';
import '../../models/inteligenceshool/materia_model.dart';
import '../../widgets/inteligence school/materia_card.dart';

class EstudianteHome extends StatelessWidget {
  final AppUser user; // Recibe el usuario
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('asignaciones')
            .where('estudianteId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final asignaciones = snapshot.data?.docs ?? [];
          if (asignaciones.isEmpty) {
            return const Center(
              child: Text(
                "No estás inscrito en ninguna materia aún.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Obtener todos los IDs de materias asignadas
          final materiaIds =
              asignaciones.map((doc) => doc['materiaId'] as String).toList();

          // Stream de materias
          return StreamBuilder<QuerySnapshot>(
            stream: _db
                .collection('materias')
                .where(FieldPath.documentId, whereIn: materiaIds)
                .snapshots(),
            builder: (context, materiasSnap) {
              if (!materiasSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final materiasDocs = materiasSnap.data!.docs;
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
      ),
    );
  }
}
