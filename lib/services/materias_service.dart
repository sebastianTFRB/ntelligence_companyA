import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inteligenceshool/materia_model.dart';

class MateriasService {
  final CollectionReference _db =
      FirebaseFirestore.instance.collection('materias');

  // 🔹 Obtener materias de un grupo
  Future<List<Materia>> obtenerMateriasPorGrupo(String grupoId) async {
    // Buscar asignaciones de ese grupo
    final asignSnapshot = await FirebaseFirestore.instance
        .collection('asignaciones')
        .where('grupoId', isEqualTo: grupoId)
        .get();

    final ids = asignSnapshot.docs.map((e) => e['materiaId'] as String).toList();
    if (ids.isEmpty) return [];

    final materiasSnap = await _db.where(FieldPath.documentId, whereIn: ids).get();
    return materiasSnap.docs
        .map((d) => Materia.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  // Obtener materias por profesor
  Future<List<Materia>> obtenerMateriasProfesor(String profesorId) async {
    final snapshot = await _db.where('profesorId', isEqualTo: profesorId).get();
    return snapshot.docs
        .map((d) => Materia.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  // Obtener materias del estudiante (opcional)
  Future<List<Materia>> obtenerMateriasEstudiante(String estudianteId) async {
    final asignSnapshot = await FirebaseFirestore.instance
        .collection('asignaciones')
        .where('estudianteId', isEqualTo: estudianteId)
        .get();

    final ids = asignSnapshot.docs.map((e) => e['materiaId'] as String).toList();
    if (ids.isEmpty) return [];

    final materiasSnap = await _db.where(FieldPath.documentId, whereIn: ids).get();
    return materiasSnap.docs
        .map((d) => Materia.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }
}
