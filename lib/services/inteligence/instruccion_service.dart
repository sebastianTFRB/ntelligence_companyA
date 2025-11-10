import 'dart:convert';
import 'package:http/http.dart' as http;

class InstruccionService {
  final String baseUrl = "http://10.0.2.2:8000/inteligen";

  // 🔹 Leer instrucción existente
  Future<String?> leerInstruccion(String materiaId) async {
    final url = Uri.parse("$baseUrl/materias/$materiaId/instruccion");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // ✅ el backend devuelve { "materiaId": "...", "texto": "..." }
      return data['texto'] ?? '';
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Error al leer instrucción: ${response.statusCode}");
    }
  }

  // 🔹 Crear nueva instrucción
  Future<void> crearInstruccion(String materiaId, String texto) async {
    final url = Uri.parse("$baseUrl/materias/$materiaId/instruccion");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"texto": texto}), // ✅ CAMBIO AQUÍ
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear instrucción: ${response.statusCode}");
    }
  }

  // 🔹 Actualizar instrucción existente
  Future<void> actualizarInstruccion(String materiaId, String texto) async {
    final url = Uri.parse("$baseUrl/materias/$materiaId/instruccion");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"texto": texto}), // ✅ CAMBIO AQUÍ
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar instrucción: ${response.statusCode}");
    }
  }

  // 🔹 Eliminar instrucción
  Future<void> eliminarInstruccion(String materiaId) async {
    final url = Uri.parse("$baseUrl/materias/$materiaId/instruccion");
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error al eliminar instrucción: ${response.statusCode}");
    }
  }
}
