// models/inteligenceshool/asignacion_profesor_model.dart
class AsignacionProfesor {
  final String id;
  final String profesorId;
  final String materiaId;
  final String grupoId;

  AsignacionProfesor({
    required this.id,
    required this.profesorId,
    required this.materiaId,
    required this.grupoId,
  });

  factory AsignacionProfesor.fromMap(Map<String, dynamic> data, String id) {
    return AsignacionProfesor(
      id: id,
      profesorId: data['profesorId'],
      materiaId: data['materiaId'],
      grupoId: data['grupoId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profesorId': profesorId,
      'materiaId': materiaId,
      'grupoId': grupoId,
    };
  }
}
