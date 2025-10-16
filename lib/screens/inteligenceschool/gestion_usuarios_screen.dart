import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/users_model.dart';
import '../../models/inteligenceshool/materia_model.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controladores y Firestore
  final _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _rolSeleccionado = 'estudiante';

  String? _materiaSeleccionada;
  String? _estudianteSeleccionado;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // 🔹 Crear usuario
  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _db.collection('users').add({
        'email': _emailController.text.trim(),
        'rol': _rolSeleccionado,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Usuario $_rolSeleccionado creado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _emailController.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear usuario: $e')),
      );
    }
  }

  // 🔹 Eliminar usuario
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

  // 🔹 Obtener materias
  Future<List<Materia>> _obtenerMaterias() async {
    final snapshot = await _db.collection('materias').get();
    return snapshot.docs.map((d) => Materia.fromMap(d.data(), d.id)).toList();
  }

  // 🔹 Obtener estudiantes
  Future<List<AppUser>> _obtenerEstudiantes() async {
    final snapshot =
        await _db.collection('users').where('rol', isEqualTo: 'estudiante').get();
    return snapshot.docs.map((d) => AppUser.fromMap(d.data(), d.id)).toList();
  }

  // 🔹 Asignar materia a estudiante
  Future<void> _asignarMateria() async {
    if (_materiaSeleccionada == null || _estudianteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona materia y estudiante.")),
      );
      return;
    }

    await _db.collection('asignaciones').add({
      'materiaId': _materiaSeleccionada,
      'estudianteId': _estudianteSeleccionado,
      'fechaAsignacion': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Materia asignada correctamente.")),
    );

    setState(() {
      _materiaSeleccionada = null;
      _estudianteSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Usuarios y Materias"),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.person_add), text: "Agregar Usuario"),
            Tab(icon: Icon(Icons.list_alt), text: "Listar Usuarios"),
            Tab(icon: Icon(Icons.school), text: "Asignar Materia"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 🟢 TAB 1 - Crear Usuario
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Registrar nuevo usuario",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Correo electrónico",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingresa un correo";
                      }
                      if (!value.contains("@")) {
                        return "Correo no válido";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _rolSeleccionado,
                    decoration: const InputDecoration(
                      labelText: "Rol",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: "estudiante", child: Text("Estudiante")),
                      DropdownMenuItem(
                          value: "profesor", child: Text("Profesor")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _rolSeleccionado = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _crearUsuario,
                    icon: const Icon(Icons.save),
                    label: const Text("Guardar Usuario"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🟣 TAB 2 - Listar Usuarios
          StreamBuilder<QuerySnapshot>(
            stream: _db.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text("No hay usuarios registrados."));
              }

              final usuarios = snapshot.data!.docs
                  .map((d) => AppUser.fromMap(d.data() as Map<String, dynamic>, d.id))
                  .toList();

              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, i) {
                  final u = usuarios[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          u.role == "profesor" ? Colors.green : Colors.orange,
                      child: Icon(
                        u.role == "profesor" ? Icons.school : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(u.email),
                    subtitle: Text("Rol: ${u.role}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarUsuario(u.uid),
                    ),
                  );
                },
              );
            },
          ),

          // 🟡 TAB 3 - Asignar Materia
          Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder(
              future: Future.wait([
                _obtenerMaterias(),
                _obtenerEstudiantes(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final materias = snapshot.data![0] as List<Materia>;
                final estudiantes = snapshot.data![1] as List<AppUser>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selecciona una materia:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _materiaSeleccionada,
                      hint: const Text("Materia"),
                      isExpanded: true,
                      items: materias
                          .map((m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.nombre),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _materiaSeleccionada = val;
                      }),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Selecciona un estudiante:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _estudianteSeleccionado,
                      hint: const Text("Estudiante"),
                      isExpanded: true,
                      items: estudiantes
                          .map((e) => DropdownMenuItem(
                                value: e.uid,
                                child: Text(e.email),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _estudianteSeleccionado = val;
                      }),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _asignarMateria,
                      icon: const Icon(Icons.add_task),
                      label: const Text("Asignar Materia"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
