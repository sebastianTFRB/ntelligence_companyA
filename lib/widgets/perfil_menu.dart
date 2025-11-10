import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilMenu extends StatelessWidget {
  const PerfilMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      elevation: 12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌈 Encabezado con degradado institucional
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A11CB), // 💜 Morado
                  Color(0xFF2575FC), // 💙 Celeste
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
              ),
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              accountName: Text(
                user?.displayName ?? 'Usuario sin nombre',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                user?.email ?? 'Sin correo',
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.deepPurple[400],
                ),
              ),
            ),
          ),

          // ⚙️ Opciones del menú
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF6A11CB)),
            title: const Text(
              "Configuración",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/configuracion");
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF6A11CB)),
            title: const Text(
              "Historial",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/historial");
            },
          ),

          const Divider(height: 30, thickness: 1, indent: 15, endIndent: 15),

          // 🚪 Botón de cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Cerrar sesión",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text("Cerrar sesión"),
                  content: const Text(
                      "¿Seguro que deseas cerrar tu sesión actual?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A11CB),
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Cerrar sesión"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sesión cerrada correctamente."),
                      backgroundColor: Color(0xFF6A11CB),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error al cerrar sesión: $e"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
          ),

          const Spacer(),

          // 🧾 Versión app
          const Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
              "Versión 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
