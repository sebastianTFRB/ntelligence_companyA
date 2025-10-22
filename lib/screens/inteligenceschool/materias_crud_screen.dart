import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MateriasCrudScreen extends StatefulWidget {
  const MateriasCrudScreen({super.key});

  @override
  State<MateriasCrudScreen> createState() => _MateriasCrudScreenState();
}

class _MateriasCrudScreenState extends State<MateriasCrudScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  /// 🔹 Crear nueva materia genérica
  Future<void> _mostrarDialogoAgregarMateria() async {
    _nombreController.clear();
    _descripcionController.clear();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Agregar Materia Genérica"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre de la materia",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: "Descripción (opcional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () async {
              final nombre = _nombreController.text.trim();
              final descripcion = _descripcionController.text.trim();
              if (nombre.isEmpty) return;

              await _db.collection("materias_genericas").add({
                "nombre": nombre,
                "descripcion": descripcion,
                "creado": FieldValue.serverTimestamp(),
              });

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Editar materia
  void _editarMateria(String id, String nombreActual, String descripcionActual) {
    _nombreController.text = nombreActual;
    _descripcionController.text = descripcionActual;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Materia"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevoNombre = _nombreController.text.trim();
              final nuevaDescripcion = _descripcionController.text.trim();

              if (nuevoNombre.isNotEmpty) {
                await _db.collection("materias_genericas").doc(id).update({
                  "nombre": nuevoNombre,
                  "descripcion": nuevaDescripcion,
                });
              }

              _nombreController.clear();
              _descripcionController.clear();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Eliminar materia
  void _eliminarMateria(String id) async {
    await _db.collection("materias_genericas").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Materias Genéricas"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection("materias_genericas")
            .orderBy("creado", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay materias registradas"));
          }

          final materias = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: materias.length,
            itemBuilder: (context, index) {
              final doc = materias[index];
              final data = doc.data() as Map<String, dynamic>;
              final nombre = data["nombre"] ?? "Sin nombre";
              final descripcion = data["descripcion"] ?? "";

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: descripcion.isNotEmpty
                      ? Text(descripcion)
                      : const Text("Sin descripción"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _editarMateria(doc.id, nombre, descripcion),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarMateria(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("Agregar Materia"),
        onPressed: _mostrarDialogoAgregarMateria,
      ),
    );
  }
}
