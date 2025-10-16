import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/users_model.dart';
import '../../models/inteligenceshool/materia_model.dart';
import '../../services/materias_service.dart';
import '../../widgets/inteligence school/materia_card.dart';

class EstudianteHome extends StatelessWidget {
  final AppUser user;
  const EstudianteHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final MateriasService materiasService = MateriasService();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido, ${user.email.split('@').first}"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Materia>>(
        future: materiasService.obtenerMateriasEstudiante(user.uid),
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
                "No estás inscrito en ninguna materia aún.",
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
    );
  }
}
