import 'package:flutter/material.dart';

class FibrilacionScreen extends StatelessWidget {
  const FibrilacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fibrilación Auricular"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Simulación de Fibrilación Auricular"),
      ),
    );
  }
}
