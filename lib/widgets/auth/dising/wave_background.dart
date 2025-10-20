import 'package:flutter/material.dart';
import 'wave_clipper.dart';

class WaveBackground extends StatefulWidget {
  const WaveBackground({super.key});

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Fondo principal con gradiente
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF8E24AA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        /// Onda superior animada
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: -100 + 10 * _controller.value,
              left: -50,
              right: -50,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        /// Curva lateral derecha translúcida
        Positioned(
          right: -100,
          top: 100,
          child: Container(
            width: 250,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(300)),
            ),
          ),
        ),

        /// Semicírculos translúcidos
        Positioned(
          bottom: -60,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 60,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
          ),
        ),

        /// Halo LED central
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFAB47BC),
                  blurRadius: 200,
                  spreadRadius: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
