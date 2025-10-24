import 'package:flutter/material.dart';
import '../../../models/users_model.dart';

class StudentHeader extends StatelessWidget implements PreferredSizeWidget {
  final AppUser user;
  final VoidCallback onMenuTap;

  const StudentHeader({
    super.key,
    required this.user,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 45, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🧑 Nombre del usuario desde Firestore
          Text(
            user.nombre.isNotEmpty
                ? user.nombre
                : user.email.split('@').first, // fallback
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ☰ Icono menú lateral
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: onMenuTap,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
