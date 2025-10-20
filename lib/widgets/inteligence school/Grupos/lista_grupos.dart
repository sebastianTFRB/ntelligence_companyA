import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelligence_company_ia/screens/inteligenceschool/detalle_grupo_screen.dart';

class ListaGrupos extends StatelessWidget {
  final FirebaseFirestore db;
  const ListaGrupos({super.key, required this.db});

  Future<void> _eliminarGrupo(BuildContext context, String id) async {
    try {
      await db.collection('grupos').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Grupo eliminado")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al eliminar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('grupos').orderBy('grado').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay grupos registrados"));
        }

        final grupos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: grupos.length,
          itemBuilder: (context, index) {
            final grupo = grupos[index];
            final data = grupo.data() as Map<String, dynamic>;
            final nombre = "Grado ${data['grado']}${data['letra']}";

            return Card(
              child: ListTile(
                leading: const Icon(Icons.class_),
                title: Text(nombre),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalleGrupoScreen(
                              grupoId: grupo.id,
                              nombreGrupo: nombre,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarGrupo(context, grupo.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
