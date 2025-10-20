import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilMenu extends StatelessWidget {
  const PerfilMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            accountName: Text("Sebastián Fajardo Delgado"),
            accountEmail: Text("sebastian@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configuración"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/configuracion");
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Historial"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/historial");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: () async {
              Navigator.pop(context); // Cierra el menú

              try {
                await FirebaseAuth.instance.signOut(); // Cierra sesión real
                // Navega al login y elimina historial
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sesión cerrada correctamente")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al cerrar sesión: $e")),
                );
              }
            },
          ),

          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Versión 1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
