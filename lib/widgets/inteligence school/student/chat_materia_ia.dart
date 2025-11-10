import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/services/inteligence/chat_service.dart';

class ChatMateriaIA extends StatefulWidget {
  final String materiaId;
  const ChatMateriaIA({super.key, required this.materiaId});

  @override
  State<ChatMateriaIA> createState() => _ChatMateriaIAState();
}

class _ChatMateriaIAState extends State<ChatMateriaIA> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> mensajes = [];
  bool loading = false;
  final ChatService _chatService = ChatService();

  // ⚡ Aquí va el ID del estudiante (en tu app vendrá del perfil o login)
  final String estudianteId = "1kXc42tfWJQ3FYba93ZtVzRjibx1";

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      mensajes.add({"role": "user", "text": texto});
      _controller.clear();
      loading = true;
    });

    final respuesta = await _chatService.enviarPregunta(
      widget.materiaId,
      texto,
      estudianteId,
    );

    setState(() {
      mensajes.add({"role": "bot", "text": respuesta});
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mensajes.length,
            itemBuilder: (context, i) {
              final msg = mensajes[i];
              final isUser = msg["role"] == "user";
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.deepPurple : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    msg["text"] ?? "",
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (loading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
