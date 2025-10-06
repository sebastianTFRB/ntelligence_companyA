import 'package:flutter/material.dart';

class ProjectSelectorMenu extends StatefulWidget {
  const ProjectSelectorMenu({super.key});

  @override
  State<ProjectSelectorMenu> createState() => _ProjectSelectorMenuState();
}

class _ProjectSelectorMenuState extends State<ProjectSelectorMenu> {
  final PageController _controller = PageController(viewportFraction: 0.6);

  final List<Map<String, String>> projects = [
    {"logo": "assets/logos/logo_D.png", "route": "/admin_home"},
    {"logo": "assets/logos/logo_C.png", "route": "/admin_home_intelligence"},
    {"logo": "assets/logos/logo_A.png", "route": "/admin_home_arritmo"},
    {"logo": "assets/logos/logo_B.png", "route": "/admin_home_recorrido"},
  ];

  late List<Map<String, String>> infiniteProjects;

  @override
  void initState() {
    super.initState();
    // 👇 Duplicamos lista para efecto visual "infinito"
    infiniteProjects = [...projects, ...projects, ...projects];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _controller,
        itemCount: infiniteProjects.length,
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          // 👇 Resetea el scroll sin notarse
          if (index == infiniteProjects.length - 1) {
            _controller.jumpToPage(projects.length);
          }
        },
        itemBuilder: (context, index) {
          final project = infiniteProjects[index % projects.length];
          return _projectCard(
            context,
            project["logo"]!,
            project["route"]!,
            index,
          );
        },
      ),
    );
  }

  Widget _projectCard(BuildContext context, String logo, String route, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = 1.0;
          if (_controller.position.haveDimensions) {
            value = (_controller.page! - index).abs();
            value = (1 - (value * 0.3)).clamp(0.85, 1.0);
          }

          return Transform.scale(
            scale: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    logo,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
