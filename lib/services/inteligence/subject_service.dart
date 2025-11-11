import 'dart:io';
import 'dart:typed_data';
import 'package:intelligence_company_ia/models/inteligenceshool/disingMateriasScreen/materia_bloque.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MateriaService {
  final _supabase = Supabase.instance.client;
  final _bucket = 'materia_media';
  final _uuid = const Uuid();

  // 🔹 Obtener bloques de una materia
  Future<List<MateriaBloque>> fetchBloques(String materiaId) async {
    final data = await _supabase
        .from('materia_bloques')
        .select()
        .eq('materia_id', materiaId)
        .order('orden', ascending: true);

    // En Supabase v2 ya no hay "execute" ni "error"
    // Devuelve directamente una lista dinámica.
    return (data as List)
        .map((e) => MateriaBloque.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // 🔹 Crear un nuevo bloque
  Future<void> createBloque({
    required String materiaId,
    required String tipo,
    String? contenido,
    String? url,
    required int orden,
  }) async {
    final payload = {
      'materia_id': materiaId,
      'tipo': tipo,
      'contenido': contenido,
      'url': url,
      'orden': orden,
    };

    await _supabase.from('materia_bloques').insert(payload);
  }

  // 🔹 Actualizar un bloque existente
  Future<void> updateBloque(String id, Map<String, dynamic> values) async {
    await _supabase.from('materia_bloques').update(values).eq('id', id);
  }

  // 🔹 Eliminar bloque
  Future<void> deleteBloque(String id) async {
    await _supabase.from('materia_bloques').delete().eq('id', id);
  }

  // 🔹 Subir imagen (archivo físico, por ejemplo en Android/iOS)
  Future<String> uploadImageFile(File file, String materiaId) async {
    final ext = file.path.split('.').last;
    final fileName = '$materiaId/${_uuid.v4()}.$ext';

    await _supabase.storage.from(_bucket).upload(fileName, file);

    final publicUrl = _supabase.storage.from(_bucket).getPublicUrl(fileName);
    return publicUrl;
  }

  // 🔹 Subir imagen desde bytes (por ejemplo en Web)
  Future<String> uploadBytes(Uint8List bytes, String filename, String materiaId) async {
    final fileName = '$materiaId/${_uuid.v4()}_$filename';

    await _supabase.storage.from(_bucket).uploadBinary(fileName, bytes);

    final publicUrl = _supabase.storage.from(_bucket).getPublicUrl(fileName);
    return publicUrl;
  }

  // 🔹 Actualizar orden de múltiples bloques
  Future<void> updateOrden(List<MateriaBloque> bloques) async {
    final updates = bloques.map((b) => {'id': b.id, 'orden': b.orden}).toList();
    await _supabase.from('materia_bloques').upsert(updates);
  }
}
