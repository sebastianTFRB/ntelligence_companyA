import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../services/arritmo_api.dart'; // 👈 servicio para Arritmo
// import "../../assets/logos/logo_A.jpg"; // 👈 logo de Arritmo
class ArritmoScreen extends StatefulWidget {
  const ArritmoScreen({super.key});

  @override
  State<ArritmoScreen> createState() => _ArritmoScreenState();
}

class _ArritmoScreenState extends State<ArritmoScreen> {
  int _currentIndex = 0;
  final TextEditingController _controller = TextEditingController();
  String _respuesta = "";
  bool _cargando = false;

  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Arritmo")),
    const Center(child: Text("Estudiantes")),
    const Center(child: Text("Configuración")),
  ];

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
      body: _currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _respuesta.isEmpty ? "Haz una pregunta a Arritmo 👇" : _respuesta,
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
            )
          : _pages[_currentIndex],
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "IATest"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Estudiantes"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
