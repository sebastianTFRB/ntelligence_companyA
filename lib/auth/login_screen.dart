import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLogin = true;
  String? selectedRole;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    try {
      if (isLogin) {
        // 🔹 LOGIN EXISTENTE
        UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        DocumentSnapshot doc = await _firestore
            .collection("users")
            .doc(userCred.user!.uid)
            .get();

        AppUser currentUser =
            AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        _redirectUser(currentUser);
      } else {
        // 🔹 NUEVO REGISTRO
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        AppUser newUser = AppUser(
          uid: userCred.user!.uid,
          email: _emailController.text.trim(),
          role: selectedRole ?? "estudiante",
        );

        await _firestore
            .collection("users")
            .doc(newUser.uid)
            .set(newUser.toMap());

        _redirectUser(newUser);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // 🔹 Actualizado para enviar el objeto AppUser
  void _redirectUser(AppUser user) {
    switch (user.role) {
      case "admin":
        Navigator.pushReplacementNamed(context, "/admin_home");
        break;
      case "profesor":
        Navigator.pushReplacementNamed(
          context,
          "/profesor_home",
          arguments: user,
        );
        break;
      default:
        Navigator.pushReplacementNamed(
          context,
          "/estudiante_home",
          arguments: user,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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

          /// Onda fluida animada
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return Positioned(
                top: -100 + 10 * _waveController.value,
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

          /// Curva lateral decorativa (derecha)
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

          /// Contenido principal
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/auth/inicio.png',
                      height: 120,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      isLogin ? "Iniciar Sesión" : "Registro",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Color(0xFF6A1B9A)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF6A1B9A), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF6A1B9A)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF6A1B9A), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Selecciona rol",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF6A1B9A), width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: selectedRole,
                        onChanged: (val) => setState(() => selectedRole = val),
                        items: ["admin", "profesor", "estudiante"].map((r) {
                          return DropdownMenuItem(value: r, child: Text(r));
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        isLogin ? "Iniciar Sesión" : "Registrarse",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin
                            ? "¿No tienes cuenta? Regístrate"
                            : "¿Ya tienes cuenta? Inicia sesión",
                        style: const TextStyle(color: Color(0xFF6A1B9A)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- CLIPPER DE LA ONDA ---
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 60);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint =
        Offset(size.width * 3 / 4, size.height - 120);
    var secondEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
