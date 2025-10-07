import 'package:flutter/material.dart';

class InstruccionesContextoScreen extends StatefulWidget {
  const InstruccionesContextoScreen({super.key});

  @override
  State<InstruccionesContextoScreen> createState() => _InstruccionesContextoScreenState();
}

class _InstruccionesContextoScreenState extends State<InstruccionesContextoScreen> {
  final List<Map<String, String>> _items = [];
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();

  void _mostrarDialogo({Map<String, String>? item, int? index}) {
    if (item != null) {
      _tituloController.text = item['titulo']!;
      _contenidoController.text = item['contenido']!;
    } else {
      _tituloController.clear();
      _contenidoController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Nueva Instrucción' : 'Editar Instrucción'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contenidoController,
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (item == null) {
                _items.add({
                  'titulo': _tituloController.text,
                  'contenido': _contenidoController.text,
                });
              } else {
                _items[index!] = {
                  'titulo': _tituloController.text,
                  'contenido': _contenidoController.text,
                };
              }
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Gestión de Instrucciones y Contextos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text("Aún no hay instrucciones registradas"))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(item['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(item['contenido']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () => _mostrarDialogo(item: item, index: index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _eliminarItem(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogo(),
        label: const Text("Agregar"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
