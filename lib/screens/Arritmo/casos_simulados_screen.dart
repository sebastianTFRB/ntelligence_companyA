import 'package:flutter/material.dart';

// 👇 Importamos cada caso individual
import 'casos_simulados/fibrilacion_screen.dart';
import 'casos_simulados/flutter_screen.dart';
import 'casos_simulados/bradicardia_screen.dart';
import 'casos_simulados/taquicardia_screen.dart';
import 'casos_simulados/wolff_screen.dart';


class CasosSimuladosScreen extends StatelessWidget {
  const CasosSimuladosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> casos = [
      {
        "nombre": "Fibrilación Auricular",
        "descripcion": "Ritmo cardíaco irregular y rápido.",
        "icono": "💓",
        "screen": const FibrilacionScreen(),
      },
      {
        "nombre": "Flutter Auricular",
        "descripcion": "Contracciones auriculares rápidas pero regulares.",
        "icono": "💫",
        "screen": const FlutterScreen(),
      },
      {
        "nombre": "Bradicardia Ventricular",
        "descripcion": "Ritmo cardíaco más lento de lo normal.",
        "icono": "🐢",
        "screen": const BradicardiaScreen(),
      },
      {
        "nombre": "Taquicardia",
        "descripcion": "Ritmo cardíaco anormalmente rápido.",
        "icono": "⚡",
        "screen": const TaquicardiaScreen(),
      },
      {
        "nombre": "Síndrome de Wolff-Parkinson-White",
        "descripcion": "Vía eléctrica adicional en el corazón.",
        "icono": "🧠",
        "screen": const WolffScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Casos Simulados por Arritmo"),
        backgroundColor: const Color(0xFF185A8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => caso['screen']),
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
                    Text(caso['icono'], style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(
                      caso['nombre'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      caso['descripcion'],
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
    );
  }
}
