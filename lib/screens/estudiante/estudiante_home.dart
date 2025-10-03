import 'package:flutter/material.dart';
import 'materia_view_screen.dart';

class EstudianteHome extends StatelessWidget {
  const EstudianteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Estudiante")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Matemáticas IV"),
            subtitle: const Text("Profesor: Juan Pérez"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MateriaViewScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Física II"),
            subtitle: const Text("Profesor: Ana López"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
