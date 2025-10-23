import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intelligence_company_ia/screens/estudiante/materiasList.dart';
import 'package:intelligence_company_ia/screens/estudiante/perfil_estudiante_screen.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/student/student_header.dart';

import '../../../models/users_model.dart';
 // ✅ (asegúrate de crear este archivo con StudentHeader)
import '../../../widgets/admin_bottom_nav.dart'; // ✅ (asegúrate de crear este archivo con AdminBottomNav)

class EstudianteHomeScreen extends StatefulWidget {
  final AppUser user;
  const EstudianteHomeScreen({super.key, required this.user});

  @override
  State<EstudianteHomeScreen> createState() => _EstudianteHomeScreenState();
}

class _EstudianteHomeScreenState extends State<EstudianteHomeScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance; // ✅ ahora sí definido correctamente
  int _selectedIndex = 0;

  late final List<Widget> _screens;

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
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ✅ Encabezado con gradiente
          StudentHeader(user: user),

          // ✅ Contenido dinámico (pantallas)
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),

      // ✅ Barra inferior personalizada
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

      // ✅ Botón de cerrar sesión en la esquina superior derecha
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, "/login");
          }
        },
        child: const Icon(Icons.logout),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
