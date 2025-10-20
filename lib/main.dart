import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:intelligence_company_ia/auth/register_screen.dart';
import 'package:intelligence_company_ia/auth/login_screen.dart';
import 'package:intelligence_company_ia/auth/splash_screen.dart';

import 'package:intelligence_company_ia/screens/admin/admin_home.dart';
import 'package:intelligence_company_ia/screens/admin/intelligence_school_screen.dart';
import 'package:intelligence_company_ia/screens/admin/arritmo_screen.dart';
import 'package:intelligence_company_ia/screens/admin/recorrido_screen.dart';
import 'package:intelligence_company_ia/screens/inteligenceschool/crud_grupos_screen.dart';

import 'package:intelligence_company_ia/screens/estudiante/estudiante_home.dart';
import 'package:intelligence_company_ia/screens/profesor/profesor_home.dart';

import 'package:intelligence_company_ia/screens/shared/profile_screen.dart';

import 'package:intelligence_company_ia/models/users_model.dart';
import 'firebase_options.dart'; // generado por flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configuración de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  runApp(IntelligenceSchoolApp());
}

class IntelligenceSchoolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Intelligence School",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/splash",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/admin_home": (context) => AdminScreen(),
        "/splash": (context) => const SplashScreen(),
        "/profile": (context) => ProfileScreen(),
        "/register": (context) => RegisterScreen(),
        "/admin_home_intelligence": (context) => const IntelligenceSchoolScreen(),
        "/admin_home_arritmo": (context) => const ArritmoScreen(),
        "/admin_home_recorrido": (context) => const RecorridoScreen(),
        '/crud_grupos': (context) => const CrudGruposScreen(),
      },
      onGenerateRoute: (settings) {
        // Pantalla Profesor
        if (settings.name == '/profesor_home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => ProfesorHome(user: user),
          );
        }

        // Pantalla Estudiante
        if (settings.name == '/estudiante_home') {
  final user = settings.arguments as AppUser;
  return MaterialPageRoute(
    builder: (_) => EstudianteHome(user: user), // No necesitas grupoId
  );
}


        return null; // Si la ruta no coincide
      },
    );
  }
}
