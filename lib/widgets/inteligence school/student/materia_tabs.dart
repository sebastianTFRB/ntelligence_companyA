import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/models/inteligenceshool/disingMateriasScreen/materia_bloque.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/student/chat_materia_ia.dart';


class MateriaTabs extends StatelessWidget {
  final TabController tabController;
  final bool loading;
  final List<MateriaBloque> bloques;
  final Widget Function(MateriaBloque) renderBloque;
  final String materiaId;

  const MateriaTabs({
    super.key,
    required this.tabController,
    required this.loading,
    required this.bloques,
    required this.renderBloque,
    required this.materiaId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs
        TabBar(
          controller: tabController,
          labelColor: Colors.deepPurple,
          indicatorColor: Colors.deepPurple,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'Contenido'),
            Tab(icon: Icon(Icons.chat_bubble_outline), text: 'IA Asistente'),
          ],
        ),

        // Contenido de cada tab
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              // ---- TAB 1: Contenido de la materia ----
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: bloques.map(renderBloque).toList(),
                      ),
                    ),

              // ---- TAB 2: Chat con IA ----
              ChatMateriaIA(materiaId: materiaId),
            ],
          ),
        ),
      ],
    );
  }
}
