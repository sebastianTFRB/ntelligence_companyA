import 'package:flutter/material.dart';

class ProjectSelectorMenu extends StatefulWidget {
  const ProjectSelectorMenu({super.key});

  @override
  State<ProjectSelectorMenu> createState() => _ProjectSelectorMenuState();
}

class _ProjectSelectorMenuState extends State<ProjectSelectorMenu> {
  final PageController _controller = PageController(viewportFraction: 0.75);

  final List<Map<String, String>> projects = [
    {"name": "Admin", "route": "/admin_home"},
    {"name": "IntelligenceSchool", "route": "/admin_home_intelligence"},
    {"name": "Arritmo", "route": "/admin_home_arritmo"},
    {"name": "Recorrido", "route": "/admin_home_recorrido"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        controller: _controller,
        itemCount: projects.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final project = projects[index];
          return _projectCard(
            context,
            project["name"]!,
            project["route"]!,
            index,
          );
        },
      ),
    );
  }

  Widget _projectCard(BuildContext context, String name, String route, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = (_controller.page! - index).abs();
          value = (1 - (value * 0.3)).clamp(0.85, 1.0);
        }
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, route);
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // fondo casi transparente
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
