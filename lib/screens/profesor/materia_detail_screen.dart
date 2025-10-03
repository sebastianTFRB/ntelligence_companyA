import 'package:flutter/material.dart';

class MateriaDetailScreen extends StatelessWidget {
  const MateriaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Materia")),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text("Periodo 1 (01/02 - 30/04)"),
            children: [
              ListTile(
                title: const Text("Tema: Derivadas"),
                subtitle: const Text("Materiales: 2 PDF"),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
              ListTile(
                title: const Text("Tema: Integrales"),
                subtitle: const Text("Materiales: 1 Word"),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Periodo 2 (01/05 - 30/07)"),
            children: [
              ListTile(
                title: const Text("Tema: Límites"),
                subtitle: const Text("Materiales: 1 PDF"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
