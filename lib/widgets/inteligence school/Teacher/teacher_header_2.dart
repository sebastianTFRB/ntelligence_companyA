import 'package:flutter/material.dart';
import 'package:intelligence_company_ia/widgets/perfil_menu.dart';
import '../../../models/users_model.dart';

class TeacherHeader2 extends StatelessWidget implements PreferredSizeWidget {
  final AppUser user;

  const TeacherHeader2({super.key, required this.user});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: preferredSize.height + topPadding,
      child: Stack(
        children: [
          // 🌈 Fondo degradado morado → celeste con onda
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: preferredSize.height + topPadding,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6A11CB), // 💜 Morado
                    Color(0xFF2575FC), // 💙 Celeste
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // 📸 Logo centrado
          SafeArea(
            top: true,
            bottom: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset(
                  'assets/logos/teachers.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 🔙 Botón de volver (esquina superior izquierda)
          SafeArea(
            top: true,
            bottom: false,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
                  tooltip: "Volver",
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 👤 Botón circular de perfil (abre PerfilMenu)
          SafeArea(
            top: true,
            bottom: false,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 280,
                          child: PerfilMenu(),
                        ),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF6A11CB),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🌊 ClipPath que genera una onda decorativa
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 25);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 25);

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 50);
    final secondEndPoint = Offset(size.width, size.height - 25);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
