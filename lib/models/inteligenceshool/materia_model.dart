class Materia {
  final String id;
  final String nombre;
  final String grupo;
  final String grado;
  final String profesorId;

  Materia({
    required this.id,
    required this.nombre,
    required this.grupo,
    required this.grado,
    required this.profesorId,
  });

  // Crear desde mapa (Firestore)
  factory Materia.fromMap(Map<String, dynamic> data, String id) {
    return Materia(
      id: id,
      nombre: data['nombre'] ?? '',
      grupo: data['grupo'] ?? '',
      grado: data['grado'] ?? '',
      profesorId: data['profesorId'] ?? '',
    );
  }

  // Convertir a mapa (para guardar/actualizar)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'grupo': grupo,
      'grado': grado,
      'profesorId': profesorId,
    };
  }
}
