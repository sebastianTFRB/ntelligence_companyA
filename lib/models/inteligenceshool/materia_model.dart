class Materia {
  final String id;
  final String nombre;
  final String descripcion;
  final String grupoId;
  final String grupoNombre;
  final String profesorId;
  final String profesorNombre;
  final String materiaGenericaId;
  final String materiaGenericaNombre; // 🔹 NUEVO campo

  Materia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.grupoId,
    required this.grupoNombre,
    required this.profesorId,
    required this.profesorNombre,
    required this.materiaGenericaId,
    required this.materiaGenericaNombre, // 🔹 inicializar
  });

  factory Materia.fromMap(Map<String, dynamic> data, String id) {
    return Materia(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      grupoId: data['grupoId'] ?? '',
      grupoNombre: data['grupoNombre'] ?? '',
      profesorId: data['profesorId'] ?? '',
      profesorNombre: data['profesorNombre'] ?? '',
      materiaGenericaId: data['materiaGenericaId'] ?? '',
      materiaGenericaNombre: data['materiaGenericaNombre'] ?? '', // 🔹 mapear
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'grupoId': grupoId,
      'grupoNombre': grupoNombre,
      'profesorId': profesorId,
      'profesorNombre': profesorNombre,
      'materiaGenericaId': materiaGenericaId,
      'materiaGenericaNombre': materiaGenericaNombre, // 🔹 guardar
    };
  }
}
