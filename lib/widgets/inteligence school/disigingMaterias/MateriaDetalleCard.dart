import 'package:flutter/material.dart';

class MateriaDetalleCard extends StatelessWidget {
  final Map<String, dynamic> materia;
  final bool editable;
  final TextEditingController? descripcionController;
  final VoidCallback? onGuardar;

  const MateriaDetalleCard({
    super.key,
    required this.materia,
    this.editable = false,
    this.descripcionController,
    this.onGuardar,
  });

  Color _getColorFondo(String materiaGenerica) {
    switch (materiaGenerica.toLowerCase()) {
      case 'sociales':
        return Colors.purple[50]!;
      case 'quimica':
        return Colors.green[50]!;
      case 'matematicas':
        return Colors.blue[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  IconData _getIconMateria(String materiaGenerica) {
    switch (materiaGenerica.toLowerCase()) {
      case 'sociales':
        return Icons.people;
      case 'quimica':
        return Icons.science;
      case 'matematicas':
        return Icons.calculate;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final materiaGenerica = materia['materiaGenericaNombre'] ?? '';
    final colorFondo = _getColorFondo(materiaGenerica);
    final iconMateria = _getIconMateria(materiaGenerica);

    return Container(
      color: colorFondo,
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(iconMateria, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      materia['nombre'] ?? '',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "${materia['grupoNombre'] ?? ''} - Prof. ${materia['profesorNombre'] ?? ''}",
                style: const TextStyle(
                    color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              if (editable)
                TextField(
                  controller: descripcionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Descripción de la materia",
                    border: OutlineInputBorder(),
                  ),
                )
              else
                Text(
                  materia['descripcion']?.isNotEmpty == true
                      ? materia['descripcion']
                      : 'Sin descripción disponible.',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              if (editable && onGuardar != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton.icon(
                    onPressed: onGuardar,
                    icon: const Icon(Icons.save),
                    label: const Text("Guardar cambios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
