import 'package:flutter/material.dart';
import '../models/instrucciones.dart';

Future<void> showCrudForm({
  required BuildContext context,
  required bool esInstruccion,
  Instruccion? existing,
  required Future<void> Function(Instruccion nuevo) onCreate,
  required Future<void> Function(String nombre, Instruccion nuevo) onUpdate,
  required VoidCallback onSaved,
}) async {
  final nombreCtrl = TextEditingController(text: existing?.nombre ?? '');
  final textoCtrl = TextEditingController(text: existing?.texto ?? '');

  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(existing == null
          ? (esInstruccion ? 'Nueva Instrucción' : 'Nuevo Contexto')
          : (esInstruccion ? 'Editar Instrucción' : 'Editar Contexto')),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              readOnly: existing != null,
            ),
            TextField(
              controller: textoCtrl,
              decoration: const InputDecoration(labelText: 'Texto'),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (nombreCtrl.text.isEmpty || textoCtrl.text.isEmpty) return;

            final nuevo = Instruccion(
              nombre: nombreCtrl.text,
              texto: textoCtrl.text,
            );

            if (existing == null) {
              await onCreate(nuevo);
            } else {
              await onUpdate(existing.nombre, nuevo);
            }

            if (context.mounted) Navigator.pop(ctx);
            onSaved();
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}
