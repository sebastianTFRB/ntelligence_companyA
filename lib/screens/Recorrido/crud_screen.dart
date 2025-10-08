import 'package:flutter/material.dart';
import '../../models/instrucciones.dart';
import '../../services/recorrido_api.dart';
import '../../widgets/crud_list_widget.dart';
import '../../widgets/crud_form_dialog.dart';
import '../../widgets/crud_confirm_delete.dart';

class CrudRecorridoScreen extends StatefulWidget {
  const CrudRecorridoScreen({super.key});

  @override
  State<CrudRecorridoScreen> createState() => _CrudRecorridoScreenState();
}

class _CrudRecorridoScreenState extends State<CrudRecorridoScreen>
    with SingleTickerProviderStateMixin {
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
    _futureInstrucciones = RecorridoApi.listarInstrucciones();
    _futureContextos = RecorridoApi.listarContextos();
  }

  void _refresh() => setState(_loadData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Gestión del Recorrido'),
        backgroundColor: Colors.blueGrey,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Instrucciones'),
            Tab(icon: Icon(Icons.article_outlined), text: 'Contexto'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CrudListWidget(
            future: _futureInstrucciones,
            esInstruccion: true,
            onRefresh: _refresh,
            onEdit: (item) async {
              await showCrudForm(
                context: context,
                esInstruccion: true,
                existing: item,
                onCreate: RecorridoApi.crearInstruccion,
                onUpdate: RecorridoApi.actualizarInstruccion,
                onSaved: _refresh,
              );
            },
            onDelete: (nombre) async {
              await showConfirmDelete(
                context: context,
                nombre: nombre,
                esInstruccion: true,
                onDelete: RecorridoApi.eliminarInstruccion,
                onDeleted: _refresh,
              );
            },
          ),
          CrudListWidget(
            future: _futureContextos,
            esInstruccion: false,
            onRefresh: _refresh,
            onEdit: (item) async {
              await showCrudForm(
                context: context,
                esInstruccion: false,
                existing: item,
                onCreate: RecorridoApi.crearContexto,
                onUpdate: RecorridoApi.actualizarContexto,
                onSaved: _refresh,
              );
            },
            onDelete: (nombre) async {
              await showConfirmDelete(
                context: context,
                nombre: nombre,
                esInstruccion: false,
                onDelete: RecorridoApi.eliminarContexto,
                onDeleted: _refresh,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          final esInstruccion = _tabController.index == 0;
          showCrudForm(
            context: context,
            esInstruccion: esInstruccion,
            onCreate: esInstruccion
                ? RecorridoApi.crearInstruccion
                : RecorridoApi.crearContexto,
            onUpdate: esInstruccion
                ? RecorridoApi.actualizarInstruccion
                : RecorridoApi.actualizarContexto,
            onSaved: _refresh,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
