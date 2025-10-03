import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';

class IntelligenceSchoolScreen extends StatefulWidget {
  const IntelligenceSchoolScreen({super.key});

  @override
  State<IntelligenceSchoolScreen> createState() => _IntelligenceSchoolScreenState();
}

class _IntelligenceSchoolScreenState extends State<IntelligenceSchoolScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Dashboard IntelligenceSchool")),
    const Center(child: Text("Usuarios")),
    const Center(child: Text("Configuración")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProjectSelectorAppBar(title: "IntelligenceSchool"),
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Usuarios"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
