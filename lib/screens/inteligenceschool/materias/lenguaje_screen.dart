import 'package:flutter/material.dart';

class LenguajeScreen extends StatelessWidget {
  const LenguajeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lenguaje"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lenguaje 📖",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Mejora tu comprensión lectora y gramática con la ayuda de IA.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Icon(Icons.menu_book_outlined,
                    size: 100, color: Colors.deepPurpleAccent.withOpacity(0.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
