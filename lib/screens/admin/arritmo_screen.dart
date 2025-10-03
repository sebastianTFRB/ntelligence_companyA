import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';

class ArritmoScreen extends StatefulWidget {
  const ArritmoScreen({super.key});

  @override
  State<ArritmoScreen> createState() => _ArritmoScreenState();
}

class _ArritmoScreenState extends State<ArritmoScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Arritmo")),
    const Center(child: Text("Estudiantes")),
    const Center(child: Text("Configuración")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProjectSelectorAppBar(title: "Arritmo"),
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Estudiantes"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
