import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://10.162.66.67:8000/inteligen";

  Future<String> enviarPregunta(String materiaId, String pregunta, String estudianteId) async {
    final url = Uri.parse("$baseUrl/chat");

    final body = {
      "pregunta": pregunta,
      "materiaId": materiaId,
      "estudianteId": estudianteId,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["respuesta"] ?? "No se recibió respuesta del servidor.";
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error de conexión con el servidor: $e";
    }
  }
}
