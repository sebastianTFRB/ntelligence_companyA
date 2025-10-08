import 'package:flutter/material.dart';
import '../../models/instrucciones.dart';
import '../../services/intelligence_api.dart';
import '../../widgets/crud_tab_view.dart';
import '../../widgets/crud_form_dialog.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen>
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
    _futureInstrucciones = IntelligenceAPI.listarInstrucciones();
    _futureContextos = IntelligenceAPI.listarContextos();
  }

  void _refresh() => setState(_loadData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Gestión Inteligencia Escolar'),
        backgroundColor: Colors.purple,
      ),
      body: CrudTabView(
        tabController: _tabController,
        futureInstrucciones: _futureInstrucciones,
        futureContextos: _futureContextos,
        onRefresh: _refresh,
        crearInstruccion: IntelligenceAPI.crearInstruccion,
        actualizarInstruccion: IntelligenceAPI.actualizarInstruccion,
        eliminarInstruccion: IntelligenceAPI.eliminarInstruccion,
        crearContexto: IntelligenceAPI.crearContexto,
        actualizarContexto: IntelligenceAPI.actualizarContexto,
        eliminarContexto: IntelligenceAPI.eliminarContexto,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          final esInstruccion = _tabController.index == 0;
          showCrudForm(
            context: context,
            esInstruccion: esInstruccion,
            onCreate: esInstruccion
                ? IntelligenceAPI.crearInstruccion
                : IntelligenceAPI.crearContexto,
            onUpdate: esInstruccion
                ? IntelligenceAPI.actualizarInstruccion
                : IntelligenceAPI.actualizarContexto,
            onSaved: _refresh,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
