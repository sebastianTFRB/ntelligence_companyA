import 'package:flutter/material.dart';
import '../../models/inteligenceshool/materia_model.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final VoidCallback? onTap;

  const MateriaCard({
    super.key,
    required this.materia,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ??
            () {
              Navigator.pushNamed(
                context,
                '/materiaDetalle',
                arguments: materia,
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.deepPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materia.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Grado: ${materia.grado}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "Grupo: ${materia.grupo}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
