import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/users_model.dart';
import '../../models/inteligenceshool/materia_model.dart';
import '../../services/materias_service.dart';
import '../../widgets/inteligence school/materia_card.dart';

// 🔹 Pantalla principal del profesor
class ProfesorHome extends StatelessWidget {
  final AppUser user;
  const ProfesorHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final MateriasService materiasService = MateriasService();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido, ${user.email.split('@').first}"),
        backgroundColor: Colors.deepPurple,
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

      // 🔹 Contenido principal
      body: FutureBuilder<List<Materia>>(
        future: materiasService.obtenerMateriasProfesor(user.uid),
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
                "No tienes materias asignadas aún.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: materias.length,
            itemBuilder: (context, index) =>
                MateriaCard(materia: materias[index]),
          );
        },
      ),

      // 🔹 Botón flotante para agregar nueva materia
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/crudmaterias', arguments: user);
        },
        label: const Text("Agregar materia"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
