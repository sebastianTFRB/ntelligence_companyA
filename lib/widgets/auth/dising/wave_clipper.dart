import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    var cp1 = Offset(size.width / 4, size.height);
    var ep1 = Offset(size.width / 2, size.height - 60);
    path.quadraticBezierTo(cp1.dx, cp1.dy, ep1.dx, ep1.dy);
    var cp2 = Offset(size.width * 3 / 4, size.height - 120);
    var ep2 = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(cp2.dx, cp2.dy, ep2.dx, ep2.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
