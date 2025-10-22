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
            tooltip: "Cerrar sesión",
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

          final grupoIds = asignacionesEst
              .map((doc) => doc['grupoId'] as String)
              .toSet()
              .toList();

          return FutureBuilder<QuerySnapshot>(
            future: _db
                .collection('materias')
                .where('grupoId', whereIn: grupoIds)
                .get(),
            builder: (context, materiasSnap) {
              if (materiasSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (materiasSnap.hasError) {
                return Center(child: Text("Error: ${materiasSnap.error}"));
              }

              final materiasDocs = materiasSnap.data?.docs ?? [];
              if (materiasDocs.isEmpty) {
                return const Center(
                  child: Text(
                    "Aún no hay materias asignadas a tu grupo.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              final materias = materiasDocs.map((d) {
                final data = d.data() as Map<String, dynamic>;
                return Materia.fromMap(data, d.id);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: materias.length,
                itemBuilder: (context, index) {
                  final materia = materias[index];
                  return MateriaCard(materia: materia);
                },
              );
            },
          );
        },
      ),
    );
  }
}
