import 'package:flutter/material.dart';
import '../../../models/users_model.dart';

class PerfilEstudianteScreen extends StatelessWidget {
  final AppUser user;
  const PerfilEstudianteScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.indigo),
              const SizedBox(height: 10),
              Text(
                user.email,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("ID: ${user.uid}"),
            ],
          ),
        ),
      ),
    );
  }
}
