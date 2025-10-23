import 'package:flutter/material.dart';
import '../../../models/users_model.dart';

class StudentHeader extends StatelessWidget {
  final AppUser user;

  const StudentHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👋 Texto de bienvenida
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "¡Hola!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                user.email.split('@').first,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // 🧑 Avatar
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/student_avatar.png'),
          ),
        ],
      ),
    );
  }
}
