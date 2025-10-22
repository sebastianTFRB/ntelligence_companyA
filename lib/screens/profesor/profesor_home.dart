import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/users_model.dart';
import 'profesor_materia_screen.dart'; // ✅ Importa la nueva pantalla

class ProfesorHome extends StatelessWidget {
  final AppUser user;
  const ProfesorHome({super.key, required this.user});

  Future<List<Map<String, dynamic>>> _obtenerMateriasProfesor(
      String profesorId) async {
    final db = FirebaseFirestore.instance;

    // 🔹 Traer todas las materias donde el profesorId coincida
    final materiasSnapshot = await db
        .collection('materias')
        .where('profesorId', isEqualTo: profesorId)
        .get();

    // 🔹 Retornar los datos con el id incluido (importante para navegar)
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
      appBar: AppBar(
        title: Text("Bienvenido, ${user.email.split('@').first}"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _obtenerMateriasProfesor(profesorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red)));
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        style:
                            const TextStyle(color: Colors.black54, fontSize: 15),
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

                  // ✅ Al hacer tap, abre el detalle editable
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfesorMateriaScreen(
                          materiaId: materia['id'], // 🔹 Pasamos el id del documento
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
    );
  }
}
