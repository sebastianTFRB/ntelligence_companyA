class Instruccion {
  final String nombre;
  final String texto;

  Instruccion({required this.nombre, required this.texto});

  factory Instruccion.fromJson(Map<String, dynamic> json) {
    return Instruccion(
      nombre: json['nombre'],
      texto: json['texto'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'texto': texto,
      };
}
