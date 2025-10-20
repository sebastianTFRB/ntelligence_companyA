import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/agregar_usuario_widget.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/listar_usuarios_widget.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/asignar_estudiante_widget.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/asignar_profesor_widget.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 🔹 ahora 4 tabs
  }

  Future<void> _eliminarUsuario(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Usuarios y Asignaciones"),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 255, 251, 5),
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.person_add), text: "Agregar Usuario"),
            Tab(icon: Icon(Icons.list_alt), text: "Listar Usuarios"),
            Tab(icon: Icon(Icons.group_add), text: "Asignar Estudiante"),
            Tab(icon: Icon(Icons.school), text: "Asignar Profesor"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AgregarUsuarioWidget(db: _db),
          ListarUsuariosWidget(db: _db, eliminarUsuario: _eliminarUsuario),
          AsignarEstudianteWidget(db: _db),
          AsignarProfesorWidget(db: _db),
        ],
      ),
    );
  }
}
