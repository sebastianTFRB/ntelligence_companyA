import 'package:flutter/material.dart';
import '../models/instrucciones.dart';

class CrudListWidget extends StatelessWidget {
  final Future<List<Instruccion>> future;
  final bool esInstruccion;
  final VoidCallback onRefresh;

  /// 🔹 Nuevos parámetros dinámicos (para desacoplar de IntelligenceAPI)
  final Future<void> Function(Instruccion item)? onEdit;
  final Future<void> Function(String nombre)? onDelete;

  const CrudListWidget({
    super.key,
    required this.future,
    required this.esInstruccion,
    required this.onRefresh,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Instruccion>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay elementos disponibles"));
        }

        final data = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, i) {
              final item = data[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item.nombre),
                  subtitle: Text(
                    item.texto,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.purple),
                        onPressed: () async {
                          if (onEdit != null) await onEdit!(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (onDelete != null) await onDelete!(item.nombre);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
