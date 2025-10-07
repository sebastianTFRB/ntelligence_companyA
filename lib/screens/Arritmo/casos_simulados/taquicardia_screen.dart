import 'package:flutter/material.dart';

class TaquicardiaScreen extends StatelessWidget {
  const TaquicardiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Taquicardia"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Simulación de Taquicardia"),
      ),
    );
  }
}
