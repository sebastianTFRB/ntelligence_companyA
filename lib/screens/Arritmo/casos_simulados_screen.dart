import 'package:flutter/material.dart';

class CasosSimuladosScreen extends StatelessWidget {
  const CasosSimuladosScreen({super.key});

  final List<Map<String, String>> casos = const [
    {"nombre": "Fibrilación Auricular", "descripcion": "Ritmo cardíaco irregular y rápido.", "icono": "💓"},
    {"nombre": "Flutter Auricular", "descripcion": "Contracciones auriculares rápidas pero regulares.", "icono": "💫"},
    {"nombre": "Bradicardia Ventricular", "descripcion": "Ritmo cardíaco más lento de lo normal.", "icono": "🐢"},
    {"nombre": "Taquicardia", "descripcion": "Ritmo cardíaco anormalmente rápido.", "icono": "⚡"},
    {"nombre": "Síndrome de Wolff-Parkinson-White", "descripcion": "Vía eléctrica adicional en el corazón.", "icono": "🧠"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Casos Simulados por Arritmo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: casos.length,
                itemBuilder: (context, index) {
                  final caso = casos[index];
                  return GestureDetector(
                    onTap: () {
                      // Aquí luego abriremos detalle o simulación
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Abrir caso: ${caso['nombre']}")),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(caso['icono']!, style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 8),
                          Text(
                            caso['nombre']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            caso['descripcion']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
