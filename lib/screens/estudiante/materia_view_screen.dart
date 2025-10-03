import 'package:flutter/material.dart';

class MateriaViewScreen extends StatelessWidget {
  const MateriaViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ver Materia")),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text("Periodo 1"),
            children: [
              ListTile(
                title: const Text("Tema: Derivadas"),
                subtitle: const Text("2 archivos"),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    // acción de descarga
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
