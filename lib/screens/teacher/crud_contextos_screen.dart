import 'package:flutter/material.dart';
import '../../services/inteligence/contex_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CrudContextosScreen extends StatefulWidget {
  final String materiaId;
  const CrudContextosScreen({super.key, required this.materiaId});

  @override
  State<CrudContextosScreen> createState() => _CrudContextosScreenState();
}

class _CrudContextosScreenState extends State<CrudContextosScreen> {
  List<String> _contextos = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _cargarContextos();
  }

  Future<void> _cargarContextos() async {
    setState(() => _loading = true);
    try {
      final lista = await ContextosService.getContextos(widget.materiaId);
      setState(() => _contextos = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar contextos: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _subirArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['txt', 'md'],
      type: FileType.custom,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() => _loading = true);
      try {
        await ContextosService.uploadContexto(widget.materiaId, file);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contexto subido correctamente ✅")),
        );
        _cargarContextos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al subir archivo: $e")),
        );
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _verArchivo(String filename) async {
    try {
      final data = await ContextosService.getContextoFile(widget.materiaId, filename);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(filename),
          content: SingleChildScrollView(
            child: Text(data['texto'] ?? 'Sin contenido'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al abrir archivo: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _subirArchivo,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.upload_file),
        label: const Text("Subir Contexto"),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : _contextos.isEmpty
              ? const Center(
                  child: Text(
                    "No hay contextos disponibles.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _contextos.length,
                  itemBuilder: (context, index) {
                    final archivo = _contextos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.description, color: Colors.deepPurple),
                        title: Text(archivo),
                        trailing: const Icon(Icons.remove_red_eye, color: Colors.deepPurple),
                        onTap: () => _verArchivo(archivo),
                      ),
                    );
                  },
                ),
    );
  }
}
