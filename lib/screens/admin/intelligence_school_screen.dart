import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../services/intelligence_api.dart';
import '../inteligenceschool/crud_screen.dart'; // 👈 importa tu pantalla CRUD
import '../inteligenceschool/materias_screen.dart'; // 👈 importa tu pantalla de materias

class IntelligenceSchoolScreen extends StatefulWidget {
  const IntelligenceSchoolScreen({super.key});

  @override
  State<IntelligenceSchoolScreen> createState() => _IntelligenceSchoolScreenState();
}

class _IntelligenceSchoolScreenState extends State<IntelligenceSchoolScreen> {
  int _currentIndex = 0;
  final TextEditingController _controller = TextEditingController();
  String _respuesta = "";
  bool _cargando = false;

  // 📚 Lista de páginas que se mostrarán en el bottom nav
  late final List<Widget> _pages = [
    _buildIATestPage(), // Página de IA
    const CrudScreen(), // CRUD de usuarios
    const MateriasScreen(), // Materias
  ];

  // 🔹 Lógica del envío de pregunta a la IA
  Future<void> _enviarPregunta() async {
    final pregunta = _controller.text.trim();
    if (pregunta.isEmpty) return;

    setState(() => _cargando = true);

    try {
      final data = await IntelligenceAPI.enviarPregunta(pregunta);
      setState(() => _respuesta = data["respuesta"]);

      // Reproducir audio si el backend lo devuelve
      if (data["audio"] != null) {
        await IntelligenceAPI.reproducirAudio(data["audio"]);
      }
    } catch (e) {
      setState(() => _respuesta = "❌ Error: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  // 🧠 Página principal de IA
  Widget _buildIATestPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _respuesta.isEmpty ? "Haz una pregunta a la IA 👇" : _respuesta,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Escribe tu pregunta...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _cargando ? null : _enviarPregunta,
              ),
            ],
          ),
          if (_cargando) const LinearProgressIndicator(),
        ],
      ),
    );
  }

  // 🧩 Construcción del Scaffold principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectSelectorAppBar(
        title: "IntelligenceSchool",
        backgroundColor: const Color.fromARGB(255, 162, 29, 211),
        customTitle: Image.asset(
          'assets/logos/logo_C.png',
          height: 250,
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: "IATest"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Usuarios"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Materias"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
