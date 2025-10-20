import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intelligence_company_ia/auth/register_screen.dart';

import 'package:intelligence_company_ia/screens/profesor/CrudMateriasScreen.dart';
import 'auth/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/admin/intelligence_school_screen.dart';
import 'screens/admin/arritmo_screen.dart';
import 'screens/admin/recorrido_screen.dart';
import 'auth/splash_screen.dart';
import 'screens/shared/profile_screen.dart';
import 'firebase_options.dart'; // generado por flutterfire configure
import 'screens/estudiante/estudiante_home.dart';
import 'screens/profesor/profesor_home.dart';
import 'models/users_model.dart';
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
        
        '/crudmaterias': (context) {
         final user = ModalRoute.of(context)!.settings.arguments as AppUser;
         return CrudMateriasScreen(user: user);
         
  },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profesor_home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => ProfesorHome(user: user),
          );
        } else if (settings.name == '/estudiante_home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => EstudianteHome(user: user),
          );
        }
        return null;
      },
    );
  }
}

