import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../models/instrucciones.dart';

class IntelligenceAPI {
  static const String baseUrl = "http://10.162.248.179:8000/inteligens"; 
  // 📌 Cambia por tu IP LAN si pruebas en físico

  // ---------------------------
  // 🧠 Chat e inteligencia
  // ---------------------------

  static Future<Map<String, dynamic>> enviarPregunta(String pregunta) async {
    final url = Uri.parse("$baseUrl/chat");
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"pregunta": pregunta}),
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      throw Exception("Error en chat: ${resp.body}");
    }
  }

  static Future<String> transcribirAudio(String base64Audio) async {
    final url = Uri.parse("$baseUrl/stt");
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"audio": base64Audio}),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data["texto"] ?? "";
    } else {
      throw Exception("Error en STT: ${resp.body}");
    }
  }

  static Future<void> reproducirAudio(String base64Audio) async {
    final audioBytes = base64Decode(base64Audio);
    final audioPlayer = AudioPlayer();
    await audioPlayer.play(BytesSource(Uint8List.fromList(audioBytes)));
  }

  // ---------------------------
  // 📚 CRUD Instrucciones
  // ---------------------------

  static Future<List<Instruccion>> listarInstrucciones() async {
    final url = Uri.parse("$baseUrl/instrucciones");
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((e) => Instruccion.fromJson(e)).toList();
    } else {
      throw Exception("Error al listar: ${resp.body}");
    }
  }

  static Future<void> crearInstruccion(Instruccion instr) async {
    final url = Uri.parse("$baseUrl/instrucciones");
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(instr.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error al crear: ${resp.body}");
    }
  }

  static Future<void> actualizarInstruccion(String nombre, Instruccion instr) async {
    final url = Uri.parse("$baseUrl/instrucciones/$nombre");
    final resp = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(instr.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error al actualizar: ${resp.body}");
    }
  }

  static Future<void> eliminarInstruccion(String nombre) async {
    final url = Uri.parse("$baseUrl/instrucciones/$nombre");
    final resp = await http.delete(url);

    if (resp.statusCode != 200) {
      throw Exception("Error al eliminar: ${resp.body}");
    }
  }

    // 📄 --- CRUD CONTEXTO ---
  static Future<List<Instruccion>> listarContextos() async {
    final url = Uri.parse("$baseUrl/docs");
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List;
      return data.map((e) => Instruccion(nombre: e["id"], texto: e["texto"])).toList();
    } else {
      throw Exception("Error al listar contextos: ${resp.body}");
    }
  }

  static Future<void> crearContexto(Instruccion doc) async {
    final url = Uri.parse("$baseUrl/docs");
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": doc.nombre, "texto": doc.texto}));
  }

  static Future<void> actualizarContexto(String id, Instruccion doc) async {
    final url = Uri.parse("$baseUrl/docs/$id");
    await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"texto": doc.texto}));
  }

  static Future<void> eliminarContexto(String id) async {
    final url = Uri.parse("$baseUrl/docs/$id");
    await http.delete(url);
  }

}
