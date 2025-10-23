import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligence_company_ia/models/inteligenceshool/disingMateriasScreen/materia_bloque.dart';
import 'package:intelligence_company_ia/services/inteligence/materia_service.dart';

class ProfesorMateriaScreen extends StatefulWidget {
  final String materiaId;
  const ProfesorMateriaScreen({super.key, required this.materiaId});

  @override
  State<ProfesorMateriaScreen> createState() => _ProfesorMateriaScreenState();
}

class _ProfesorMateriaScreenState extends State<ProfesorMateriaScreen> {
  final MateriaService _service = MateriaService();
  List<MateriaBloque> bloques = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      bloques = await _service.fetchBloques(widget.materiaId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _addBloqueSimple(String tipo) async {
    final siguienteOrden = bloques.isEmpty ? 0 : (bloques.map((b) => b.orden).reduce((a, b) => a > b ? a : b) + 1);
    if (tipo == 'imagen') {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      final file = File(picked.path);
      final url = await _service.uploadImageFile(file, widget.materiaId);
      await _service.createBloque(materiaId: widget.materiaId, tipo: 'imagen', url: url, orden: siguienteOrden);
    } else {
      // abrir dialog para ingresar contenido
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          final ctrl = TextEditingController();
          return AlertDialog(
            title: Text('Nuevo ${tipo == 'titulo' ? 'Título' : tipo == 'subtitulo' ? 'Subtítulo' : 'Texto'}'),
            content: TextField(controller: ctrl, maxLines: tipo == 'texto' ? 5 : 1),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Agregar'))
            ],
          );
        },
      );
      if (result != null && result.trim().isNotEmpty) {
        await _service.createBloque(materiaId: widget.materiaId, tipo: tipo, contenido: result.trim(), orden: siguienteOrden);
      }
    }
    await _load();
  }

  Future<void> _delete(String id) async {
    await _service.deleteBloque(id);
    await _load();
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = bloques.removeAt(oldIndex);
    bloques.insert(newIndex, item);
    // actualizar orden en memoria
    for (var i = 0; i < bloques.length; i++) {
      bloques[i] = MateriaBloque(
        id: bloques[i].id,
        materiaId: bloques[i].materiaId,
        tipo: bloques[i].tipo,
        contenido: bloques[i].contenido,
        url: bloques[i].url,
        orden: i,
      );
    }
    // push a supabase
    await _service.updateOrden(bloques);
    setState(() {});
  }

  Widget _buildTile(MateriaBloque b) {
    return ListTile(
      key: ValueKey(b.id),
      title: Text('${b.tipo.toUpperCase()} ${b.tipo != 'imagen' && (b.contenido?.length ?? 0) > 30 ? ' — ${b.contenido!.substring(0,30)}...' : ''}'),
      leading: b.tipo == 'imagen' ? const Icon(Icons.image) : const Icon(Icons.text_fields),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: const Icon(Icons.edit), onPressed: () => _editBloque(b)),
        IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(b.id)),
      ]),
    );
  }

  Future<void> _editBloque(MateriaBloque b) async {
    if (b.tipo == 'imagen') {
      // permitir reemplazar imagen
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      final url = await _service.uploadImageFile(File(picked.path), widget.materiaId);
      await _service.updateBloque(b.id, {'url': url});
    } else {
      final ctrl = TextEditingController(text: b.contenido ?? '');
      final res = await showDialog<String?>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Editar ${b.tipo}'),
          content: TextField(controller: ctrl, maxLines: b.tipo == 'texto' ? 5 : 1),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Guardar'))
          ],
        ),
      );
      if (res != null) {
        await _service.updateBloque(b.id, {'contenido': res});
      }
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Constructor de Materia'), backgroundColor: Colors.deepPurple),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              onReorder: _onReorder,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: bloques.map(_buildTile).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => SafeArea(
              child: Wrap(
                children: [
                  ListTile(leading: const Icon(Icons.title), title: const Text('Título'), onTap: () { Navigator.pop(context); _addBloqueSimple('titulo'); }),
                  ListTile(leading: const Icon(Icons.subtitles), title: const Text('Subtítulo'), onTap: () { Navigator.pop(context); _addBloqueSimple('subtitulo'); }),
                  ListTile(leading: const Icon(Icons.text_fields), title: const Text('Texto'), onTap: () { Navigator.pop(context); _addBloqueSimple('texto'); }),
                  ListTile(leading: const Icon(Icons.image), title: const Text('Imagen'), onTap: () { Navigator.pop(context); _addBloqueSimple('imagen'); }),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
