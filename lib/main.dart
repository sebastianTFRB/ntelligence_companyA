import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'auth/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/admin/intelligence_school_screen.dart';
import 'screens/admin/arritmo_screen.dart';
import 'screens/admin/recorrido_screen.dart';
import 'screens/profesor/profesor_home.dart';
import 'screens/estudiante/estudiante_home.dart';
import 'screens/shared/profile_screen.dart';
import 'firebase_options.dart'; // generado por flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configuración de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparente
    statusBarIconBrightness: Brightness.light, // iconos claros
    statusBarBrightness: Brightness.dark, // iOS
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
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginScreen(),
        "/admin_home": (context) => AdminScreen(),
        "/profesor_home": (context) => ProfesorHome(),
        "/estudiante_home": (context) => EstudianteHome(),
        "/profile": (context) => ProfileScreen(),
        "/admin_home_intelligence": (context) => const IntelligenceSchoolScreen(),
        "/admin_home_arritmo": (context) => const ArritmoScreen(),
        "/admin_home_recorrido": (context) => const RecorridoScreen(),
      },
    );
  }
}
