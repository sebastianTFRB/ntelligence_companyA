import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/widgets/admins/crud_form_dialog.dart';
import 'package:intelligence_company_ia/widgets/admins/crud_list_widget.dart';
import '../../models/instrucciones.dart';

import 'crud_confirm_delete.dart';

class CrudTabView extends StatefulWidget {
  final TabController tabController;
  final Future<List<Instruccion>> futureInstrucciones;
  final Future<List<Instruccion>> futureContextos;
  final VoidCallback onRefresh;

  /// Funciones de API (inyectadas según el módulo)
  final Future<void> Function(Instruccion) crearInstruccion;
  final Future<void> Function(String, Instruccion) actualizarInstruccion;
  final Future<void> Function(String) eliminarInstruccion;

  final Future<void> Function(Instruccion) crearContexto;
  final Future<void> Function(String, Instruccion) actualizarContexto;
  final Future<void> Function(String) eliminarContexto;

  const CrudTabView({
    super.key,
    required this.tabController,
    required this.futureInstrucciones,
    required this.futureContextos,
    required this.onRefresh,
    required this.crearInstruccion,
    required this.actualizarInstruccion,
    required this.eliminarInstruccion,
    required this.crearContexto,
    required this.actualizarContexto,
    required this.eliminarContexto,
  });

  @override
  State<CrudTabView> createState() => _CrudTabViewState();
}

class _CrudTabViewState extends State<CrudTabView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: widget.tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.rule), text: 'Instrucciones'),
            Tab(icon: Icon(Icons.menu_book), text: 'Contexto'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              CrudListWidget(
                future: widget.futureInstrucciones,
                esInstruccion: true,
                onRefresh: widget.onRefresh,
                onEdit: (item) async {
                  await showCrudForm(
                    context: context,
                    esInstruccion: true,
                    existing: item,
                    onCreate: widget.crearInstruccion,
                    onUpdate: widget.actualizarInstruccion,
                    onSaved: widget.onRefresh,
                  );
                },
                onDelete: (nombre) async {
                  await showConfirmDelete(
                    context: context,
                    nombre: nombre,
                    esInstruccion: true,
                    onDelete: widget.eliminarInstruccion,
                    onDeleted: widget.onRefresh,
                  );
                },
              ),
              CrudListWidget(
                future: widget.futureContextos,
                esInstruccion: false,
                onRefresh: widget.onRefresh,
                onEdit: (item) async {
                  await showCrudForm(
                    context: context,
                    esInstruccion: false,
                    existing: item,
                    onCreate: widget.crearContexto,
                    onUpdate: widget.actualizarContexto,
                    onSaved: widget.onRefresh,
                  );
                },
                onDelete: (nombre) async {
                  await showConfirmDelete(
                    context: context,
                    nombre: nombre,
                    esInstruccion: false,
                    onDelete: widget.eliminarContexto,
                    onDeleted: widget.onRefresh,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
