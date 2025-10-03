import 'package:flutter/material.dart';
import 'materia_detail_screen.dart';

class ProfesorHome extends StatelessWidget {
  const ProfesorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Profesor")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Matemáticas IV"),
            subtitle: const Text("3 periodos"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MateriaDetailScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Física II"),
            subtitle: const Text("2 periodos"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
