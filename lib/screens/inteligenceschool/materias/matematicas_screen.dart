import 'package:flutter/material.dart';
import 'base_screen.dart';

class MatematicasScreen extends StatelessWidget {
  const MatematicasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Matemáticas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conceptos Básicos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aquí podrás repasar álgebra, trigonometría, cálculo y más. '
            'Selecciona un tema para comenzar.',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.calculate_outlined, color: Colors.blueAccent),
            title: const Text('Álgebra Lineal'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.functions, color: Colors.purpleAccent),
            title: const Text('Cálculo Diferencial'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.grid_on, color: Colors.orangeAccent),
            title: const Text('Geometría Analítica'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
