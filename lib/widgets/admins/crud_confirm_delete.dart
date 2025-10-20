import 'package:flutter/material.dart';

Future<void> showConfirmDelete({
  required BuildContext context,
  required String nombre,
  required bool esInstruccion,
  required Future<void> Function(String nombre) onDelete,
  required VoidCallback onDeleted,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(esInstruccion ? 'Eliminar Instrucción' : 'Eliminar Contexto'),
      content: Text('¿Seguro que deseas eliminar "$nombre"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            await onDelete(nombre);
            if (context.mounted) Navigator.pop(ctx);
            onDeleted();
          },
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
}
