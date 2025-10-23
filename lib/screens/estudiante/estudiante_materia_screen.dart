import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/models/inteligenceshool/disingMateriasScreen/materia_bloque.dart';
import 'package:intelligence_company_ia/services/inteligence/materia_service.dart';


class EstudianteMateriaScreen extends StatefulWidget {
  final String materiaId;
  const EstudianteMateriaScreen({super.key, required this.materiaId});

  @override
  State<EstudianteMateriaScreen> createState() => _EstudianteMateriaScreenState();
}

class _EstudianteMateriaScreenState extends State<EstudianteMateriaScreen> {
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
    bloques = await _service.fetchBloques(widget.materiaId);
    setState(() => loading = false);
  }

  Widget _renderBloque(MateriaBloque b) {
    switch (b.tipo) {
      case 'titulo':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(b.contenido ?? '', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        );
      case 'subtitulo':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(b.contenido ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        );
      case 'texto':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(b.contenido ?? '', style: const TextStyle(fontSize: 16, height: 1.4)),
        );
      case 'imagen':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: b.url != null ? Image.network(b.url!) : const SizedBox.shrink(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materia'), backgroundColor: Colors.deepPurple),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bloques.map(_renderBloque).toList(),
              ),
            ),
    );
  }
}
