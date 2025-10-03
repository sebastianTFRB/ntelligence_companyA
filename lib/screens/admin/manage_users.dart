import 'package:flutter/material.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestionar Usuarios")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Usuario 1 - Profesor"),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Usuario 2 - Estudiante"),
          ),
        ],
      ),
    );
  }
}
