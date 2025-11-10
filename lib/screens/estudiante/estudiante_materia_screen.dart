import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
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
  State<EstudianteMateriaScreen> createState() =>
      _EstudianteMateriaScreenState();
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

  // 🌈 Fondo decorativo con ondas y degradado suave
  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -60,
          left: -40,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 120,
          right: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -80,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }

  // 🎬 Bloques con diseño elegante y animación
  Widget _renderBloque(MateriaBloque b, int index) {
    final animationDelay = Duration(milliseconds: (index * 120).clamp(0, 800));

    Widget content;

    switch (b.tipo) {
      case 'titulo':
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              (b.contenido ?? '').toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 65, 8, 209),
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        );
        break;

      case 'subtitulo':
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              b.contenido ?? '',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 10, 135, 238),
                letterSpacing: 1.1,
              ),
            ),
          ),
        );
        break;

      case 'texto':
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            b.contenido ?? '',
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF212121),
            ),
          ),
        );
        break;

      case 'imagen':
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: b.url != null
                  ? Image.network(
                      b.url!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
        break;

      case 'cita':
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              border: const Border(
                left: BorderSide(color: Colors.deepPurple, width: 4),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              b.contenido ?? '',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
          ),
        );
        break;

      default:
        content = const SizedBox.shrink();
    }

    return FadeInUp(
      delay: animationDelay,
      duration: const Duration(milliseconds: 600),
      child: content,
    );
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: StudentHeader(
          user: widget.user,
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          MateriaTabs(
            tabController: _tabController,
            loading: loading,
            bloques: bloques,
            renderBloque: (b) => _renderBloque(b, bloques.indexOf(b)),
            materiaId: widget.materiaId,
          ),
        ],
      ),
    );
  }
}
