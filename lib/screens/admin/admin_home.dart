import 'package:flutter/material.dart';
import '../../widgets/project_selector_appbar.dart';
import '../../widgets/admin_bottom_nav.dart';
import 'intelligence_school_screen.dart';
import 'arritmo_screen.dart';
import 'recorrido_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    // 🔹 Aquí decides a qué screen ir
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IntelligenceSchoolScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ArritmoScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RecorridoScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectSelectorAppBar(
        title: "Arritmo",
        backgroundColor: const Color.fromARGB(255, 107, 194, 190), 
        customTitle: Image.asset(
          'assets/logos/logo_D.png',
          height: 250,
        ),
      ),
      body: const Center(child: Text("Pantalla Principal del Admin")),
      bottomNavigationBar: AdminBottomNav(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Intelligence"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Arritmo"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Recorrido"),
        ],
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
