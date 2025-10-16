import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/users_model.dart';

class ListarUsuariosScreen extends StatefulWidget {
  const ListarUsuariosScreen({super.key});

  @override
  State<ListarUsuariosScreen> createState() => _ListarUsuariosScreenState();
}

class _ListarUsuariosScreenState extends State<ListarUsuariosScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _filtroRol = 'todos';

  Future<void> _eliminarUsuario(String uid) async {
    try {
      await _db.collection('usuarios').doc(uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Query usuariosQuery = _db.collection('usuarios');

    if (_filtroRol != 'todos') {
      usuariosQuery = usuariosQuery.where('role', isEqualTo: _filtroRol);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Usuarios'),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<String>(
            initialValue: _filtroRol,
            onSelected: (value) {
              setState(() => _filtroRol = value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'todos', child: Text('Todos')),
              PopupMenuItem(value: 'profesor', child: Text('Profesores')),
              PopupMenuItem(value: 'estudiante', child: Text('Estudiantes')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usuariosQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados'));
          }

          final usuarios = snapshot.data!.docs
              .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: usuarios.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = usuarios[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: user.role == 'profesor'
                      ? Colors.green
                      : Colors.orange,
                  child: Icon(
                    user.role == 'profesor' ? Icons.school : Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(user.email),
                subtitle: Text('Rol: ${user.role}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirmar eliminación'),
                        content: Text(
                            '¿Seguro que deseas eliminar al usuario "${user.email}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _eliminarUsuario(user.uid);
                            },
                            child: const Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
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
