import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inteligenceshool/materia_model.dart';

class MateriasService {
  final CollectionReference _db =
      FirebaseFirestore.instance.collection('materias');

  // Obtener materias por profesor
  Future<List<Materia>> obtenerMateriasProfesor(String profesorId) async {
    final snapshot =
        await _db.where('profesorId', isEqualTo: profesorId).get();
    return snapshot.docs
        .map((d) => Materia.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  // Obtener materias del estudiante (vía 'asignaciones' -> materiaId)
  Future<List<Materia>> obtenerMateriasEstudiante(String estudianteId) async {
    final asignSnapshot = await FirebaseFirestore.instance
        .collection('asignaciones')
        .where('estudianteId', isEqualTo: estudianteId)
        .get();

    final ids = asignSnapshot.docs.map((e) => e['materiaId'] as String).toList();

    if (ids.isEmpty) return [];

    // Firestore limita whereIn a 10 ids por query — si hay >10 necesitarás paginar/batch
    final materiasSnap = await _db.where(FieldPath.documentId, whereIn: ids).get();
    return materiasSnap.docs
        .map((d) => Materia.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  // Agregar nueva materia (el id lo crea Firestore)
  Future<DocumentReference> agregarMateria(Materia materia) async {
    return await _db.add(materia.toMap());
  }

  // Actualizar materia por id
  Future<void> actualizarMateria(String id, Materia materia) async {
    await _db.doc(id).update(materia.toMap());
  }

  // Eliminar materia por id
  Future<void> eliminarMateria(String id) async {
    await _db.doc(id).delete();
  }
}
