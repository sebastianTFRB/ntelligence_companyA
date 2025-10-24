import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/models/inteligenceshool/disingMateriasScreen/materia_bloque.dart';
import 'package:intelligence_company_ia/services/inteligence/materia_service.dart';
import 'package:intelligence_company_ia/widgets/inteligence school/student/materia_tabs.dart';
import 'package:intelligence_company_ia/widgets/inteligence school/student/student_header.dart';
import 'package:intelligence_company_ia/widgets/perfil_menu.dart';

import '../../../models/users_model.dart';

class EstudianteMateriaScreen extends StatefulWidget {
  final String materiaId;
  final AppUser user;

  const EstudianteMateriaScreen({
    super.key,
    required this.materiaId,
    required this.user,
  });

  @override
  State<EstudianteMateriaScreen> createState() => _EstudianteMateriaScreenState();
}

class _EstudianteMateriaScreenState extends State<EstudianteMateriaScreen>
    with SingleTickerProviderStateMixin {
  final MateriaService _service = MateriaService();
  List<MateriaBloque> bloques = [];
  bool loading = true;
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          child: Text(
            b.contenido ?? '',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        );
      case 'subtitulo':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            b.contenido ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        );
      case 'texto':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            b.contenido ?? '',
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const PerfilMenu(),

      // ✅ Encabezado reutilizado (sin texto “Hola”)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: StudentHeader(
          user: widget.user,
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),

      body: MateriaTabs(
        tabController: _tabController,
        loading: loading,
        bloques: bloques,
        renderBloque: _renderBloque,
        materiaId: widget.materiaId,
      ),
    );
  }
}
