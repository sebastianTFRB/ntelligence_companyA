import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/widgets/admins/crud_form_dialog.dart';
import '../../models/instrucciones.dart';
import '../../services/arritmo_api.dart';
import '../../widgets/admins/crud_tab_view.dart';


class CrudArritmoScreen extends StatefulWidget {
  const CrudArritmoScreen({super.key});

  @override
  State<CrudArritmoScreen> createState() => _CrudArritmoScreenState();
}

class _CrudArritmoScreenState extends State<CrudArritmoScreen>
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
    _futureInstrucciones = ArritmoApi.listarInstrucciones();
    _futureContextos = ArritmoApi.listarContextos();
  }

  void _refresh() => setState(_loadData);

  Future<void> _recargarDatos() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recargando datos...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      await ArritmoApi.recargarDatos(); // 👈 llama al endpoint /recargar_datos
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos y documentos recargados ✅')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al recargar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text('Gestión Arritmo'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: CrudTabView(
              tabController: _tabController,
              futureInstrucciones: _futureInstrucciones,
              futureContextos: _futureContextos,
              onRefresh: _refresh,
              crearInstruccion: ArritmoApi.crearInstruccion,
              actualizarInstruccion: ArritmoApi.actualizarInstruccion,
              eliminarInstruccion: ArritmoApi.eliminarInstruccion,
              crearContexto: ArritmoApi.crearContexto,
              actualizarContexto: ArritmoApi.actualizarContexto,
              eliminarContexto: ArritmoApi.eliminarContexto,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _recargarDatos,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Recargar datos y documentos",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          final esInstruccion = _tabController.index == 0;
          showCrudForm(
            context: context,
            esInstruccion: esInstruccion,
            onCreate: esInstruccion
                ? ArritmoApi.crearInstruccion
                : ArritmoApi.crearContexto,
            onUpdate: esInstruccion
                ? ArritmoApi.actualizarInstruccion
                : ArritmoApi.actualizarContexto,
            onSaved: _refresh,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
