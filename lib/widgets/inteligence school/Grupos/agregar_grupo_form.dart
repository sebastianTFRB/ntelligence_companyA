import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarGrupoForm extends StatefulWidget {
  final FirebaseFirestore db;
  const AgregarGrupoForm({super.key, required this.db});

  @override
  State<AgregarGrupoForm> createState() => _AgregarGrupoFormState();
}

class _AgregarGrupoFormState extends State<AgregarGrupoForm> {
  final _gradoController = TextEditingController();
  final _letraController = TextEditingController();

  Future<void> _agregarGrupo() async {
    final gradoText = _gradoController.text.trim();
    final letra = _letraController.text.trim().toUpperCase();

    if (gradoText.isEmpty || letra.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final grado = int.tryParse(gradoText);
    if (grado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El grado debe ser un número")),
      );
      return;
    }

    try {
      await widget.db.collection('grupos').add({
        'grado': grado,
        'letra': letra,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _gradoController.clear();
      _letraController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Grupo agregado correctamente")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al agregar grupo: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _gradoController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Grado (ej: 5)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _letraController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: "Letra del grupo (ej: A)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _agregarGrupo,
          icon: const Icon(Icons.add),
          label: const Text("Agregar Grupo"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
