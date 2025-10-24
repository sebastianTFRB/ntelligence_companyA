import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/models/users_model.dart';
import 'package:intelligence_company_ia/screens/estudiante/estudiante_materia_screen.dart';
import '../../../models/inteligenceshool/materia_model.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final AppUser user; // 👈 añadimos el usuario aquí

  const MateriaCard({
    super.key,
    required this.materia,
    required this.user,
  });

  // 🔹 Map con estilos según materia genérica
  Map<String, dynamic> _getEstilo(String materiaGenerica) {
    switch (materiaGenerica.toLowerCase()) {
      case 'sociales':
        return {
          "colorPrincipal": Colors.deepPurple,
          "colorSecundario": Colors.purple[100],
          "icono": Icons.public
        };
      case 'quimica':
        return {
          "colorPrincipal": Colors.green[800],
          "colorSecundario": Colors.green[100],
          "icono": Icons.science
        };
      case 'matematicas':
        return {
          "colorPrincipal": Colors.blue[800],
          "colorSecundario": Colors.blue[100],
          "icono": Icons.calculate
        };
      default:
        return {
          "colorPrincipal": Colors.grey[800],
          "colorSecundario": Colors.grey[200],
          "icono": Icons.school
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final estilo = _getEstilo(materia.materiaGenericaNombre);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      color: estilo["colorSecundario"],
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EstudianteMateriaScreen(
                materiaId: materia.id,
                user: user, // 👈 lo pasamos directamente, sin nulls ni route args
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: estilo["colorPrincipal"],
                child: Icon(estilo["icono"], color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materia.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Profesor: ${materia.profesorNombre}",
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      "Grupo: ${materia.grupoNombre}",
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    if (materia.descripcion.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          materia.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.indigo),
            ],
          ),
        ),
      ),
    );
  }
}
