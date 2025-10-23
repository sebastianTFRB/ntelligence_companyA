class MateriaBloque {
  final String id;
  final String materiaId;
  final String tipo; // 'titulo','subtitulo','texto','imagen'
  final String? contenido;
  final String? url;
  final int orden;

  MateriaBloque({
    required this.id,
    required this.materiaId,
    required this.tipo,
    this.contenido,
    this.url,
    required this.orden,
  });

  factory MateriaBloque.fromMap(Map<String, dynamic> m) {
    return MateriaBloque(
      id: m['id'] as String,
      materiaId: m['materia_id'] as String,
      tipo: m['tipo'] as String,
      contenido: m['contenido'] as String?,
      url: m['url'] as String?,
      orden: (m['orden'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'materia_id': materiaId,
        'tipo': tipo,
        'contenido': contenido,
        'url': url,
        'orden': orden,
      };
}
