class AppUser {
  final String uid;
  final String email;
  final String role;
  final String nombre; // 👈 Nuevo campo

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.nombre,
  });

  // Crear objeto desde Firestore
  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      email: data['email'] ?? '',
      role: data['role'] ?? 'estudiante',
      nombre: data['nombre'] ?? '', // 👈 nuevo campo
    );
  }

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "role": role,
      "nombre": nombre, // 👈 incluido en guardado
    };
  }
}
