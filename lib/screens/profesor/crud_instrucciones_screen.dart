import 'package:flutter/material.dart';
import '../../services/inteligence/instruccion_service.dart';

class CrudInstruccionesScreen extends StatefulWidget {
  final String materiaId;
  const CrudInstruccionesScreen({super.key, required this.materiaId});

  @override
  State<CrudInstruccionesScreen> createState() => _CrudInstruccionesScreenState();
}

class _CrudInstruccionesScreenState extends State<CrudInstruccionesScreen> {
  final InstruccionService _service = InstruccionService();
  final TextEditingController _controller = TextEditingController();
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarInstruccion();
  }

  Future<void> _cargarInstruccion() async {
    setState(() => _cargando = true);
    try {
      final texto = await _service.leerInstruccion(widget.materiaId);
      if (texto != null) _controller.text = texto;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar: $e")),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _guardar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() => _cargando = true);
    try {
      await _service.actualizarInstruccion(widget.materiaId, texto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Instrucción actualizada ✅")),
      );
    } catch (e) {
      try {
        await _service.crearInstruccion(widget.materiaId, texto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Instrucción creada ✅")),
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar: $err")),
        );
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _eliminar() async {
    setState(() => _cargando = true);
    try {
      await _service.eliminarInstruccion(widget.materiaId);
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Instrucción eliminada 🗑️")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar: $e")),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _recargarDatos() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recargando datos...'),
        duration: Duration(seconds: 2),
      ),
    );
    await _cargarInstruccion();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text('Gestión de Instrucción'),
        backgroundColor: const Color.fromARGB(255, 64, 241, 215),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _controller,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: "Instrucción de la Materia",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 82, 238, 255),
                          minimumSize: const Size(130, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text("Guardar", style: TextStyle(color: Colors.white)),
                        onPressed: _guardar,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          minimumSize: const Size(130, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text("Eliminar", style: TextStyle(color: Colors.white)),
                        onPressed: _eliminar,
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 82, 255, 241),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _recargarDatos,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      "Recargar datos",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
