import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfesorMateriaScreen extends StatefulWidget {
  final String materiaId;
  const ProfesorMateriaScreen({super.key, required this.materiaId});

  @override
  State<ProfesorMateriaScreen> createState() => _ProfesorMateriaScreenState();
}

class _ProfesorMateriaScreenState extends State<ProfesorMateriaScreen> {
  final _descripcionController = TextEditingController();
  bool _isSaving = false;

  Future<Map<String, dynamic>?> _obtenerMateria() async {
    final doc = await FirebaseFirestore.instance
        .collection('materias')
        .doc(widget.materiaId)
        .get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<void> _guardarCambios() async {
    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('materias')
          .doc(widget.materiaId)
          .update({'descripcion': _descripcionController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cambios guardados con éxito ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Materia"),
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
          _descripcionController.text = materia['descripcion'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  materia['nombre'] ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  materia['grupoNombre'] ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descripcionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Descripción de la materia",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _guardarCambios,
                  icon: const Icon(Icons.save),
                  label: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Guardar cambios"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
