import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../services/arritmo_api.dart';

// 🔹 Importamos las nuevas pantallas
import '../Arritmo/casos_simulados_screen.dart';
import '../Arritmo/instrucciones_contexto_screen.dart';


class ArritmoScreen extends StatefulWidget {
  const ArritmoScreen({super.key});

  @override
  State<ArritmoScreen> createState() => _ArritmoScreenState();
}

class _ArritmoScreenState extends State<ArritmoScreen> {
  int _currentIndex = 0; // Empieza en la sección de IA
  final TextEditingController _controller = TextEditingController();
  String _respuesta = "";
  bool _cargando = false;

  Future<void> _enviarPregunta() async {
    final pregunta = _controller.text.trim();
    if (pregunta.isEmpty) return;

    setState(() => _cargando = true);

    try {
      final data = await ArritmoApi.enviarPregunta(pregunta);
      setState(() => _respuesta = data["respuesta"] ?? "Sin respuesta");

      if (data["audio"] != null) {
        await ArritmoApi.reproducirAudio(data["audio"]);
      }
    } catch (e) {
      setState(() => _respuesta = "❌ Error: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  // 🔹 Cada índice del bottom nav corresponde a una pantalla
  Widget _getSelectedPage() {
    switch (_currentIndex) {
      case 0:
        // 🧠 Página principal de IA
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _respuesta.isEmpty
                        ? "Haz una pregunta a Arritmo 👇"
                        : _respuesta,
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

      case 1:
        // 🧩 CRUD de instrucciones
        return const CrudArritmoScreen();

      case 2:
        //  Casos simulados
        return const CasosSimuladosScreen();

      default:
        return const Center(child: Text("Sección desconocida"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectSelectorAppBar(
        title: "Arritmo",
        backgroundColor: const Color.fromARGB(255, 24, 90, 141),
        customTitle: Image.asset(
          'assets/logos/logo_A.png',
          height: 250,
        ),
      ),
      body: _getSelectedPage(),
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: "IATest"),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: "Instrucciones"),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: "Casos"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
