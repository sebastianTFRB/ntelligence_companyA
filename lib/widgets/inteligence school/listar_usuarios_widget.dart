import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/users_model.dart';

class ListarUsuariosWidget extends StatelessWidget {
  final FirebaseFirestore db;
  final Future<void> Function(String uid) eliminarUsuario;

  const ListarUsuariosWidget({
    super.key,
    required this.db,
    required this.eliminarUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay usuarios registrados."));
        }

        final usuarios = snapshot.data!.docs
            .map((d) => AppUser.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList();

        return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: (context, i) {
            final u = usuarios[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    u.role == "profesor" ? Colors.green : Colors.orange,
                child: Icon(
                  u.role == "profesor" ? Icons.school : Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(u.email),
              subtitle: Text("Rol: ${u.role}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => eliminarUsuario(u.uid),
              ),
            );
          },
        );
      },
    );
  }
}
