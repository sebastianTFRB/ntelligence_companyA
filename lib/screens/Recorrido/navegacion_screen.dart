import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/recorrido_api.dart';

class NavegacionScreen extends StatefulWidget {
  const NavegacionScreen({super.key});

  @override
  State<NavegacionScreen> createState() => _NavegacionScreenState();
}

class _NavegacionScreenState extends State<NavegacionScreen> {
  String _nodoActual = "Cargando...";
  final TextEditingController _controller = TextEditingController();
  bool _cargando = false;
  String _info = "";
  Timer? _timer; // ⏱️ para actualizar automáticamente

  @override
  void initState() {
    super.initState();
    _inicializarNodo();
    _iniciarActualizacionPeriodica(); // 🔄 actualización automática cada 3 seg
  }

  @override
  void dispose() {
    _timer?.cancel(); // ❌ detener el timer al salir
    _controller.dispose();
    super.dispose();
  }

  /// Inicializa el nodo con el valor actual del backend
  Future<void> _inicializarNodo() async {
    try {
      final data = await RecorridoApi.obtenerNodoActual();
      setState(() {
        _nodoActual = data["nodo_actual"] ?? "Desconocido";
        _info = data["info"] ?? "";
      });
    } catch (e) {
      setState(() => _info = "Error al obtener nodo inicial: $e");
    }
  }

  /// Actualiza el nodo manualmente desde el TextField
  Future<void> _actualizarNodo() async {
    final nodo = _controller.text.trim();
    if (nodo.isEmpty) return;

    setState(() => _cargando = true);

    try {
      final data = await RecorridoApi.actualizarNodo(nodo);
      setState(() {
        _nodoActual = data["nodo"] ?? "Desconocido";
        _info = data["info"] ?? "";
      });
    } catch (e) {
      setState(() {
        _info = "Error al actualizar nodo: $e";
      });
    } finally {
      setState(() => _cargando = false);
    }
  }

  /// 🔄 Consulta automática del nodo actual cada 3 segundos
  void _iniciarActualizacionPeriodica() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final data = await RecorridoApi.obtenerNodoActual();
        if (mounted) {
          setState(() {
            _nodoActual = data["nodo_actual"] ?? _nodoActual;
            _info = data["info"] ?? "";
          });
        }
      } catch (_) {
        // Silencioso, evita errores en la consola si el servidor no responde
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 64, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              "Lugar actual:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              _nodoActual,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_info.isNotEmpty)
              Text(
                _info,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Cambiar nodo (ej: laboratorio, aula1...)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _cargando ? null : _actualizarNodo,
              icon: const Icon(Icons.sync),
              label: const Text("Actualizar Nodo"),
            ),
            if (_cargando)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
