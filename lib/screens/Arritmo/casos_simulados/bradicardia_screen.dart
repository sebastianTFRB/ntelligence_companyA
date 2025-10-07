import 'package:flutter/material.dart';

class BradicardiaScreen extends StatelessWidget {
  const BradicardiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bradicardia Ventricular"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Simulación de Bradicardia Ventricular"),
      ),
    );
  }
}
