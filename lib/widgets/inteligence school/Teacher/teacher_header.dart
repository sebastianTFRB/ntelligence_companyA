import 'package:flutter/material.dart';
import '../../../models/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherHeader extends StatelessWidget {
  final AppUser user;

  const TeacherHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🎨 Fondo con degradado y sombra suave
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFFFFA837)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 👨‍🏫 Ícono de profesor más pequeño y profesional
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(width: 15),

              // 📘 Nombre del profesor
              Expanded(
                child: Text(
                  "Profesor ${user.email.split('@').first}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // 🔘 Botón de cerrar sesión (superior derecha)
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 22),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ),
      ],
    );
  }
}
