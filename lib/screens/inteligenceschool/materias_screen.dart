import 'package:flutter/material.dart';
import './materias/matematicas_screen.dart';
import './materias/lenguaje_screen.dart';
import './materias/ciencias_screen.dart';
import './materias/historia_screen.dart';
import './materias/ingles_screen.dart';

class MateriasScreen extends StatelessWidget {
  const MateriasScreen({super.key});

  final List<Map<String, dynamic>> materias = const [
    {"nombre": "Matemáticas", "descripcion": "Aprendizaje adaptativo con IA.", "icono": "🧮"},
    {"nombre": "Lenguaje", "descripcion": "Comprensión lectora y gramática.", "icono": "📖"},
    {"nombre": "Ciencias Naturales", "descripcion": "Experimentos y simulaciones.", "icono": "🔬"},
    {"nombre": "Historia", "descripcion": "Explora eventos históricos con IA.", "icono": "🏛️"},
    {"nombre": "Inglés", "descripcion": "Conversación y práctica guiada.", "icono": "🗣️"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Materias con Inteligencia Artificial"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final materia = materias[index];

            return GestureDetector(
              onTap: () {
                // Navegación a cada pantalla según el nombre
                switch (materia['nombre']) {
                  case "Matemáticas":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MatematicasScreen()));
                    break;
                  case "Lenguaje":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LenguajeScreen()));
                    break;
                  case "Ciencias Naturales":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CienciasScreen()));
                    break;
                  case "Historia":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HistoriaScreen()));
                    break;
                  case "Inglés":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const InglesScreen()));
                    break;
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(materia['icono']!, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(
                      materia['nombre']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      materia['descripcion']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
