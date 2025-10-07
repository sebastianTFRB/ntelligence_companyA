import 'package:flutter/material.dart';

class InglesScreen extends StatelessWidget {
  const InglesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inglés"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inglés 🗣️",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Practica pronunciación, vocabulario y conversación con IA.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Icon(Icons.chat_bubble_outline,
                    size: 100, color: Colors.deepPurpleAccent.withOpacity(0.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
