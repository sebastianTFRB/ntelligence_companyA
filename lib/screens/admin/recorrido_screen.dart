import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';

class RecorridoScreen extends StatefulWidget {
  const RecorridoScreen({super.key});

  @override
  State<RecorridoScreen> createState() => _RecorridoScreenState();
}

class _RecorridoScreenState extends State<RecorridoScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Mapa del Recorrido")),
    const Center(child: Text("Puntos de Interés")),
    const Center(child: Text("Configuración")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProjectSelectorAppBar(title: "Recorrido"),
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: "Puntos"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
