import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelligence_company_ia/screens/profesor/ProfesorMateriaTabs.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/Teacher/teacher_header.dart';
import '../../models/users_model.dart';

class ProfesorHome extends StatelessWidget {
  final AppUser user;
  const ProfesorHome({super.key, required this.user});

  Future<List<Map<String, dynamic>>> _obtenerMateriasProfesor(String profesorId) async {
    final db = FirebaseFirestore.instance;

    // 🔹 Traer todas las materias donde el profesorId coincida
    final materiasSnapshot = await db
        .collection('materias')
        .where('profesorId', isEqualTo: profesorId)
        .get();

    // 🔹 Retornar los datos con el id incluido
    return materiasSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'nombre': data['nombre'] ?? 'Sin nombre',
        'descripcion': data['descripcion'] ?? '',
        'grupoNombre': data['grupoNombre'] ?? 'Sin grupo',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final profesorId = user.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 👨‍🏫 Header personalizado del profesor
          TeacherHeader(user: user),

          // 📚 Lista de materias
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _obtenerMateriasProfesor(profesorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final materias = snapshot.data ?? [];

                if (materias.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aún no tienes materias asignadas.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: materias.length,
                  itemBuilder: (context, index) {
                    final materia = materias[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.menu_book, color: Colors.white),
                        ),
                        title: Text(
                          materia['nombre'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              materia['grupoNombre'],
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 15),
                            ),
                            if (materia['descripcion'].isNotEmpty)
                              Text(
                                materia['descripcion'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black45),
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.deepPurple),

                        // ✅ Tap para ir al detalle
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfesorMateriaTabs(
                              materiaId: materia['id'],
                              user: user, // 👈 AGREGA ESTA LÍNEA
                            ),
                          ),
                        );
                      },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
