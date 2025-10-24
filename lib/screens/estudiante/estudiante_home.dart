import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intelligence_company_ia/screens/estudiante/materiasList.dart';
import 'package:intelligence_company_ia/screens/estudiante/perfil_estudiante_screen.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/student/student_header.dart';
import 'package:intelligence_company_ia/widgets/perfil_menu.dart';


import '../../../models/users_model.dart';
import '../../../widgets/admin_bottom_nav.dart';

class EstudianteHomeScreen extends StatefulWidget {
  final AppUser user;
  const EstudianteHomeScreen({super.key, required this.user});

  @override
  State<EstudianteHomeScreen> createState() => _EstudianteHomeScreenState();
}

class _EstudianteHomeScreenState extends State<EstudianteHomeScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // 👈 para abrir el Drawer

  @override
  void initState() {
    super.initState();
    _screens = [
      Materiaslist(user: widget.user),
      PerfilEstudianteScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      key: _scaffoldKey, // 👈 necesario para abrir el Drawer
      backgroundColor: Colors.grey[100],

      drawer: const PerfilMenu(), // 👈 tu menú lateral reutilizado

      body: Column(
        children: [
          // ✅ Header con callback del menú
          StudentHeader(
            user: user,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(), // 👈 abre el Drawer
          ),

          // ✅ Contenido dinámico
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),

      // ✅ Barra inferior
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Materias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
