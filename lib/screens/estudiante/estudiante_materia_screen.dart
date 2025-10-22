import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EstudianteMateriaScreen extends StatelessWidget {
  final String materiaId;
  const EstudianteMateriaScreen({super.key, required this.materiaId});

  Future<Map<String, dynamic>?> _obtenerMateria() async {
    final doc = await FirebaseFirestore.instance
        .collection('materias')
        .doc(materiaId)
        .get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Color _getColorFondo(String materiaGenerica) {
    switch (materiaGenerica.toLowerCase()) {
      case 'sociales':
        return Colors.purple[50]!;
      case 'quimica':
        return Colors.green[50]!;
      case 'matematicas':
        return Colors.blue[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Materia"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _obtenerMateria(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Materia no encontrada"));
          }

          final materia = snapshot.data!;
          final colorFondo =
              _getColorFondo(materia['materiaGenericaNombre'] ?? '');

          return Container(
            color: colorFondo,
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  materia['nombre'] ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "${materia['grupoNombre'] ?? ''} - Prof. ${materia['profesorNombre'] ?? ''}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  materia['descripcion']?.isNotEmpty == true
                      ? materia['descripcion']
                      : 'Sin descripción disponible.',
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
