import 'package:flutter/material.dart';
import 'project_selector_menu.dart';

/// AppBar con título centrado, efecto de animación al pulsar,
/// botón de perfil circular y fondo con forma de onda personalizada.
class ProjectSelectorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const ProjectSelectorAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: preferredSize.height + topPadding,
      child: Stack(
        children: [
          // Fondo con ondas cubriendo también la barra de estado
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: preferredSize.height + topPadding,
              color: Colors.blue.shade700,
            ),
          ),

          // Título centrado con animación dentro de SafeArea
          SafeArea(
            top: true,
            bottom: false,
            child: Center(
              child: GestureDetector(
                onTap: () => _showProjectSelector(context),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, scale, child) {
                    return AnimatedScale(
                      scale: scale,
                      duration: const Duration(milliseconds: 150),
                      child: child,
                    );
                  },
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botón circular de perfil alineado a la derecha con padding
          SafeArea(
            top: true,
            bottom: false,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20), // más separación del borde
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/perfil");
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue.shade700,
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

  void _showProjectSelector(BuildContext context) {
    final RenderBox appBarBox = context.findRenderObject() as RenderBox;
    final Offset offset = appBarBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent, // sin oscurecer fondo
      builder: (_) {
        return Stack(
          children: [
            Positioned(
              top: offset.dy + kToolbarHeight, // justo debajo del AppBar
              left: 20,
              right: 20,
              child: const ProjectSelectorMenu(),
            ),
          ],
        );
      },
    );
  }
}

/// CustomClipper que genera un efecto de onda
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 20);

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    final secondEndPoint = Offset(size.width, size.height - 20);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
