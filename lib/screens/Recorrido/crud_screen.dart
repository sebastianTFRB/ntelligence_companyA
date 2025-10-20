import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/widgets/admins/crud_form_dialog.dart';
import '../../models/instrucciones.dart';
import '../../services/recorrido_api.dart';
import '../../widgets/admins/crud_tab_view.dart';

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
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Gestión Recorrido Virtual'),
        backgroundColor: Colors.green,
      ),
      body: CrudTabView(
        tabController: _tabController,
        futureInstrucciones: _futureInstrucciones,
        futureContextos: _futureContextos,
        onRefresh: _refresh,
        crearInstruccion: RecorridoApi.crearInstruccion,
        actualizarInstruccion: RecorridoApi.actualizarInstruccion,
        eliminarInstruccion: RecorridoApi.eliminarInstruccion,
        crearContexto: RecorridoApi.crearContexto,
        actualizarContexto: RecorridoApi.actualizarContexto,
        eliminarContexto: RecorridoApi.eliminarContexto,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
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
