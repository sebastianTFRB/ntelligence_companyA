import 'package:flutter/material.dart';

class WolffScreen extends StatelessWidget {
  const WolffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Síndrome de Wolff-Parkinson-White"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Simulación del Síndrome de Wolff-Parkinson-White"),
      ),
    );
  }
}
