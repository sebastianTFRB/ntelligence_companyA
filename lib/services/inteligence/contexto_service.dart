import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ContextosService {
  static const String baseUrl = "http://10.0.2.2:8000/inteligen"; // 🔹 Ajusta si es necesario

  // 📤 POST - subir archivo de contexto
  static Future<Map<String, dynamic>> uploadContexto(String materiaId, File archivo) async {
    final url = Uri.parse('$baseUrl/materias/$materiaId/contexto');

    final request = http.MultipartRequest('POST', url);
// por ahora asumimos txt/md

    request.files.add(
      await http.MultipartFile.fromPath(
        'archivo',
        archivo.path,
        filename: path.basename(archivo.path),
        contentType: MediaType('text', 'plain'),
      ),
    );

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(respStr);
    } else {
      throw Exception("Error al subir contexto: ${response.statusCode} - $respStr");
    }
  }

  // 📥 GET - listar archivos de contexto
  static Future<List<String>> getContextos(String materiaId) async {
    final url = Uri.parse('$baseUrl/materias/$materiaId/contextos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List archivos = data['contextos'] ?? [];
      return archivos.map((a) => a.toString()).toList();
    } else {
      throw Exception("Error al obtener contextos");
    }
  }

  // 📄 GET - obtener contenido de un archivo
  static Future<Map<String, dynamic>> getContextoFile(String materiaId, String filename) async {
    final url = Uri.parse('$baseUrl/materias/$materiaId/contextos/$filename');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Archivo no encontrado");
    }
  }
}
