// models/inteligenceshool/grupo_model.dart
class Grupo {
  final String id;
  final int grado;
  final String letra;

  Grupo({required this.id, required this.grado, required this.letra});

  factory Grupo.fromMap(Map<String, dynamic> data, String id) {
    return Grupo(
      id: id,
      grado: data['grado'],
      letra: data['letra'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grado': grado,
      'letra': letra,
    };
  }

  String get nombre => "$grado$letra";
}
