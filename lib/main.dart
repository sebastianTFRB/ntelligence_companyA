import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:intelligence_company_ia/auth/register_screen.dart';
import 'package:intelligence_company_ia/auth/login_screen.dart';
import 'package:intelligence_company_ia/auth/splash_screen.dart';

import 'package:intelligence_company_ia/screens/admin/admin_home.dart';
import 'package:intelligence_company_ia/screens/admin/intelligence_school_screen.dart';
import 'package:intelligence_company_ia/screens/admin/arritmo_screen.dart';
import 'package:intelligence_company_ia/screens/admin/recorrido_screen.dart';
import 'package:intelligence_company_ia/screens/estudiante/estudiante_home.dart';
import 'package:intelligence_company_ia/screens/inteligenceschool/crud_grupos_screen.dart';

import 'package:intelligence_company_ia/screens/profesor/profesor_home.dart';
import 'package:intelligence_company_ia/screens/shared/profile_screen.dart';

// Importa las nuevas pantallas de bloques (ajusta la ruta según tu proyecto)
import 'package:intelligence_company_ia/screens/profesor/profesor_materia_screen.dart';
import 'package:intelligence_company_ia/screens/estudiante/estudiante_materia_screen.dart';

import 'package:intelligence_company_ia/models/users_model.dart';
import 'firebase_options.dart'; // generado por flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase (ya lo tenías)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa Supabase (para la funcionalidad de bloques/media)
  //
  // Reemplaza con tus valores de Supabase. 
  // Alternativa segura: carga desde variables de entorno o archivo seguro.
  await Supabase.initialize(
    url: 'https://ixcynopazubbfqjoortd.supabase.co',        // <- reemplaza
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4Y3lub3BhenViYmZxam9vcnRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyNDA0OTQsImV4cCI6MjA3NjgxNjQ5NH0.Y7ZQoyQZKuIJpbte_ca-AlmY9v51GQ8gK2Il51B3W1c',           // <- reemplaza
  );

  // Configuración de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  runApp(const IntelligenceSchoolApp());
}

class IntelligenceSchoolApp extends StatelessWidget {
  const IntelligenceSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Intelligence School",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // si usas DeepPurple en muchas pantallas, puedes cambiar aquí:
        // colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.deepPurple),
      ),
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
        // Pantalla Profesor (recibe AppUser)
        if (settings.name == '/profesor_home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => ProfesorHome(user: user),
          );
        }

        // Pantalla Estudiante (recibe AppUser)
        if (settings.name == '/estudiante_home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => EstudianteHomeScreen(user: user),
          );
        }

        // Pantalla: Profesor -> Editor de Materia (constructor de bloques)
        // Aquí esperamos recibir un String materiaId como argumento.
        if (settings.name == '/profesor_materia') {
          final materiaId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ProfesorMateriaScreen(materiaId: materiaId),
          );
        }

        // Pantalla: Estudiante -> Ver Materia (solo lectura)
       if (settings.name == '/estudiante_materia') {
        final args = settings.arguments as Map<String, dynamic>;
        final materiaId = args['materiaId'] as String;
        final user = args['user'] as AppUser;

        return MaterialPageRoute(
          builder: (_) => EstudianteMateriaScreen(
            materiaId: materiaId,
            user: user,
          ),
        );
      }

        return null; // Si la ruta no coincide
      },
    );
  }
}
