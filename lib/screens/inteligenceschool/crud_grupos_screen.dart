import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/Grupos/agregar_grupo_form.dart';
import 'package:intelligence_company_ia/widgets/inteligence%20school/Grupos/lista_grupos.dart';


class CrudGruposScreen extends StatefulWidget {
  const CrudGruposScreen({super.key});

  @override
  State<CrudGruposScreen> createState() => _CrudGruposScreenState();
}

class _CrudGruposScreenState extends State<CrudGruposScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Grupos"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AgregarGrupoForm(db: _db),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              child: ListaGrupos(db: _db),
            ),
          ],
        ),
      ),
    );
  }
}
