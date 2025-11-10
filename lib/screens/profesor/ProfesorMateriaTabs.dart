import 'package:flutter/material.dart';
import "../../widgets/inteligence school/Teacher/teacher_header_2.dart";
import '../../../models/users_model.dart';
import 'profesor_materia_screen.dart';
import 'crud_instrucciones_screen.dart';
import 'crud_contextos_screen.dart';

class ProfesorMateriaTabs extends StatelessWidget {
  final String materiaId;
  final AppUser user;

  const ProfesorMateriaTabs({
    super.key,
    required this.materiaId,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: TeacherHeader2(user: user),
        body: Column(
          children: [
            const SizedBox(height: 10),

            // 🎨 TabBar minimalista (sin degradados, con animación sutil)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Color(0xFF6A11CB), // 💜 línea fina morada
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 20.0),
                ),
                labelColor: Color(0xFF6A11CB),
                unselectedLabelColor: Colors.black54,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                tabs: [
                  Tab(icon: Icon(Icons.build), text: 'Constructor'),
                  Tab(icon: Icon(Icons.text_snippet), text: 'Instrucciones'),
                  Tab(icon: Icon(Icons.language), text: 'Contexto'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 📄 Contenido de las pestañas
            Expanded(
              child: TabBarView(
                children: [
                  ProfesorMateriaScreen(materiaId: materiaId),
                  CrudInstruccionesScreen(materiaId: materiaId),
                  CrudContextosScreen(materiaId: materiaId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
