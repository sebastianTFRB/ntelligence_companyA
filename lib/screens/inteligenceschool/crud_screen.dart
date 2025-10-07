import 'package:flutter/material.dart';
import '../../models/instrucciones.dart';
import '../../services/intelligence_api.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Future<List<Instruccion>> _futureInstrucciones;
  late Future<List<Instruccion>> _futureContextos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    _futureInstrucciones = IntelligenceAPI.listarInstrucciones();
    _futureContextos = IntelligenceAPI.listarContextos(); // 👈 Nuevo endpoint para docs
  }

  void _refresh() {
    setState(_loadData);
  }

  // 🔹 Reutilizamos el mismo formulario para crear o editar
  void _showForm({
    required bool esInstruccion,
    Instruccion? existing,
  }) {
    final nombreCtrl = TextEditingController(text: existing?.nombre ?? '');
    final textoCtrl = TextEditingController(text: existing?.texto ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null
            ? (esInstruccion ? 'Nueva Instrucción' : 'Nuevo Contexto')
            : (esInstruccion ? 'Editar Instrucción' : 'Editar Contexto')),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                readOnly: existing != null,
              ),
              TextField(
                controller: textoCtrl,
                decoration: const InputDecoration(labelText: 'Texto'),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nombreCtrl.text.isEmpty || textoCtrl.text.isEmpty) return;
              final nuevo = Instruccion(nombre: nombreCtrl.text, texto: textoCtrl.text);

              if (esInstruccion) {
                if (existing == null) {
                  await IntelligenceAPI.crearInstruccion(nuevo);
                } else {
                  await IntelligenceAPI.actualizarInstruccion(existing.nombre, nuevo);
                }
              } else {
                if (existing == null) {
                  await IntelligenceAPI.crearContexto(nuevo);
                } else {
                  await IntelligenceAPI.actualizarContexto(existing.nombre, nuevo);
                }
              }

              if (mounted) Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String nombre, bool esInstruccion) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(esInstruccion ? 'Eliminar Instrucción' : 'Eliminar Contexto'),
        content: Text('¿Seguro que deseas eliminar "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (esInstruccion) {
                await IntelligenceAPI.eliminarInstruccion(nombre);
              } else {
                await IntelligenceAPI.eliminarContexto(nombre);
              }
              if (mounted) Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget reutilizable para mostrar cada lista CRUD
  Widget _buildCrudList({
    required Future<List<Instruccion>> future,
    required bool esInstruccion,
  }) {
    return FutureBuilder<List<Instruccion>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: Text(esInstruccion
                ? 'No hay instrucciones registradas'
                : 'No hay contextos registrados'),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: ListTile(
                title: Text(item.nombre),
                subtitle: Text(
                  item.texto,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showForm(esInstruccion: esInstruccion, existing: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(item.nombre, esInstruccion),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🧩 Pantalla principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Gestión Inteligencia Escolar'),
        backgroundColor: Colors.purple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.rule), text: 'Instrucciones'),
            Tab(icon: Icon(Icons.menu_book), text: 'Contexto'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCrudList(future: _futureInstrucciones, esInstruccion: true),
          _buildCrudList(future: _futureContextos, esInstruccion: false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          final esInstruccion = _tabController.index == 0;
          _showForm(esInstruccion: esInstruccion);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
