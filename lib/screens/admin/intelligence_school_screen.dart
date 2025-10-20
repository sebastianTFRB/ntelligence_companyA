import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/screens/inteligenceschool/crud_grupos_screen.dart';
import 'package:intelligence_company_ia/screens/inteligenceschool/gestion_usuarios_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../services/intelligence_api.dart';

// 🔹 Pantallas del módulo IntelligenceSchool
import '../inteligenceschool/crud_screen.dart';


 // ✅ NUEVA pantalla

class IntelligenceSchoolScreen extends StatefulWidget {
  const IntelligenceSchoolScreen({super.key});

  @override
  State<IntelligenceSchoolScreen> createState() =>
      _IntelligenceSchoolScreenState();
}

class _IntelligenceSchoolScreenState extends State<IntelligenceSchoolScreen> {
  int _currentIndex = 0;
  final TextEditingController _controller = TextEditingController();
  String _respuesta = "";
  bool _cargando = false;

  // 🔹 Enviar pregunta a la IA
  Future<void> _enviarPregunta() async {
    final pregunta = _controller.text.trim();
    if (pregunta.isEmpty) return;

    setState(() => _cargando = true);

    try {
      final data = await IntelligenceAPI.enviarPregunta(pregunta);
      setState(() => _respuesta = data["respuesta"] ?? "Sin respuesta");

      if (data["audio"] != null) {
        await _reproducirAudioBase64(data["audio"]);
      }
    } catch (e) {
      setState(() => _respuesta = "❌ Error: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _reproducirAudioBase64(String base64Audio) async {
    try {
      final bytes = base64Decode(base64Audio);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp_audio.wav');
      await file.writeAsBytes(bytes, flush: true);
      final audioPlayer = AudioPlayer();
      await audioPlayer.play(DeviceFileSource(file.path));
    } catch (e) {
      debugPrint("Error reproduciendo audio: $e");
    }
  }

  // 🧠 Página de prueba con IA
  Widget _buildIATestPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _respuesta.isEmpty
                    ? "Haz una pregunta a la IA 👇"
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
  }

  // 🔹 Selección de pantallas según el índice del BottomNavigationBar
  Widget _getSelectedPage() {
    switch (_currentIndex) {
      case 0:
        return _buildIATestPage(); // IA// ✅ Nuevo Dashboard
      case 1:
        return const CrudScreen(); // CRUD de usuarios (detallado)
      case 2:
        return const CrudGruposScreen(); // Materias
      case 3:
        return const GestionUsuariosScreen();  // Asignar materia
      default:
        return const Center(child: Text("Sección desconocida"));
    }
  }

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
      body: _getSelectedPage(),
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: "IA"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Usuarios"),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_add_sharp), label: "Grupos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit_outlined), label: "Gestor"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
