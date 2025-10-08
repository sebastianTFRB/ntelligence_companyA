import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../services/recorrido_api.dart';
import '../Recorrido/crud_screen.dart';
import '../Recorrido/navegacion_screen.dart';

class RecorridoScreen extends StatefulWidget {
  const RecorridoScreen({super.key});

  @override
  State<RecorridoScreen> createState() => _RecorridoScreenState();
}

class _RecorridoScreenState extends State<RecorridoScreen> {
  int _currentIndex = 0;
  final TextEditingController _controller = TextEditingController();
  String _respuesta = "";
  bool _cargando = false;

  Future<void> _enviarPregunta() async {
    final pregunta = _controller.text.trim();
    if (pregunta.isEmpty) return;

    setState(() => _cargando = true);

    try {
      final data = await RecorridoApi.enviarPregunta(pregunta);
      setState(() => _respuesta = data["respuesta"] ?? "Sin respuesta");

      if (data["audio"] != null) {
        await RecorridoApi.reproducirAudio(data["audio"]);
      }
    } catch (e) {
      setState(() => _respuesta = "❌ Error: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  /// 🔹 Determina qué pantalla se muestra según el índice
  Widget _getSelectedPage() {
    switch (_currentIndex) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _respuesta.isEmpty
                        ? "Haz una pregunta sobre el recorrido 👇"
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
        return const CrudRecorridoScreen();

      case 2:
        return const NavegacionScreen();

      default:
        return const Center(child: Text("Sección desconocida"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectSelectorAppBar(
        title: "Recorrido",
        backgroundColor: const Color.fromARGB(255, 82, 214, 150),
        customTitle: Image.asset(
          'assets/logos/logo_B.png',
          height: 250,
        ),
      ),
      body: _getSelectedPage(),
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "IA"),
          BottomNavigationBarItem(icon: Icon(Icons.folder_copy), label: "CRUD"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Navegación"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
