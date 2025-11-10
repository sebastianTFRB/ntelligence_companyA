import 'package:flutter/material.dart';
import 'profesor_materia_screen.dart';
import 'crud_instrucciones_screen.dart';

class ProfesorMateriaTabs extends StatelessWidget {
  final String materiaId;
  const ProfesorMateriaTabs({super.key, required this.materiaId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Materia'),
          backgroundColor: Colors.deepPurple,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.build), text: 'Constructor'),
              Tab(icon: Icon(Icons.text_snippet), text: 'Instrucciones'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfesorMateriaScreen(materiaId: materiaId),
            CrudInstruccionesScreen(materiaId: materiaId),
          ],
        ),
      ),
    );
  }
}
