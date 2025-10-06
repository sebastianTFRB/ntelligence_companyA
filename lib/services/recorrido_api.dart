import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';



class RecorridoApi {
  static const String baseUrl = "http://10.0.2.2:8000/recorrido"; // 📌 Cambia por tu backend (Android usa 10.0.2.2, en físico pon tu IP LAN)

  static Future<Map<String, dynamic>> enviarPregunta(String pregunta) async {
    final url = Uri.parse("$baseUrl/chat");
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"pregunta": pregunta}));

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      throw Exception("Error en chat: ${resp.body}");
    }
  }

  static Future<String> transcribirAudio(String base64Audio) async {
    final url = Uri.parse("$baseUrl/stt");
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"audio": base64Audio}));

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
}
