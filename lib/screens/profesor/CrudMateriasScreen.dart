import 'package:flutter/material.dart';
import '../../models/inteligenceshool/materia_model.dart';
import '../../models/users_model.dart';
import '../../services/materias_service.dart';

class CrudMateriasScreen extends StatefulWidget {
  final AppUser user;

  const CrudMateriasScreen({super.key, required this.user});

  @override
  State<CrudMateriasScreen> createState() => _CrudMateriasScreenState();
}

class _CrudMateriasScreenState extends State<CrudMateriasScreen> {
  final MateriasService _materiasService = MateriasService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Materia>>(
        future: _materiasService.obtenerMateriasProfesor(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final materias = snapshot.data ?? [];

          if (materias.isEmpty) {
            return const Center(
              child: Text(
                "No tienes materias registradas.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: materias.length,
            itemBuilder: (context, index) {
              final materia = materias[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  title: Text(materia.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Grado: ${materia.grado}  |  Grupo: ${materia.grupo}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _mostrarDialogoMateria(context, materia);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await _confirmarEliminar(context);
                          if (confirm) {
                            await _materiasService.eliminarMateria(materia.id);
                            setState(() {});
                          }
                        },
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
        onPressed: () {
          _mostrarDialogoMateria(context, null);
        },
        icon: const Icon(Icons.add),
        label: const Text("Nueva materia"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // 🔹 Diálogo para agregar/editar materia
  void _mostrarDialogoMateria(BuildContext context, Materia? materia) {
    final TextEditingController nombreController =
        TextEditingController(text: materia?.nombre ?? '');
    final TextEditingController gradoController =
        TextEditingController(text: materia?.grado ?? '');
    final TextEditingController grupoController =
        TextEditingController(text: materia?.grupo ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(materia == null ? "Agregar Materia" : "Editar Materia"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre de la materia"),
            ),
            TextField(
              controller: gradoController,
              decoration: const InputDecoration(labelText: "Grado"),
            ),
            TextField(
              controller: grupoController,
              decoration: const InputDecoration(labelText: "Grupo"),
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
              final nombre = nombreController.text.trim();
              final grado = gradoController.text.trim();
              final grupo = grupoController.text.trim();

              if (nombre.isEmpty || grado.isEmpty || grupo.isEmpty) return;

              if (materia == null) {
                // Crear nueva
                await _materiasService.agregarMateria(
                  Materia(
                    id: '',
                    nombre: nombre,
                    grupo: grupo,
                    grado: grado,
                    profesorId: widget.user.uid,
                  ),
                );
              } else {
                // Actualizar existente
                await _materiasService.actualizarMateria(
                  materia.id,
                  Materia(
                    id: materia.id,
                    nombre: nombre,
                    grupo: grupo,
                    grado: grado,
                    profesorId: widget.user.uid,
                  ),
                );
              }

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  // 🔹 Confirmación antes de eliminar
  Future<bool> _confirmarEliminar(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar materia?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }
}
