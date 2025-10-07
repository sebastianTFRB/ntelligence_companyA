import 'package:flutter/material.dart';

class CienciasScreen extends StatelessWidget {
  const CienciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ciencias Naturales"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ciencias Naturales 🔬",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Explora experimentos y simulaciones interactivas impulsadas por IA.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Icon(Icons.science_outlined,
                    size: 100, color: Colors.deepPurpleAccent.withOpacity(0.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
