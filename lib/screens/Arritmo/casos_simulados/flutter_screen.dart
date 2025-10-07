import 'package:flutter/material.dart';

class FlutterScreen extends StatelessWidget {
  const FlutterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Auricular"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Simulación de Flutter Auricular"),
      ),
    );
  }
}
