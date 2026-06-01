import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';

/// Reads and updates technique notes on [RoutineExercise] (Drift).
class ExerciseTechniquesService {
  ExerciseTechniquesService(this._db);

  final AppDatabase _db;

  Future<String?> storedTechniquesTrimmed(String routineExerciseId) async {
    final row = await (_db.select(_db.routineExercises)
          ..where((e) => e.id.equals(routineExerciseId)))
        .getSingleOrNull();
    if (row == null) return null;
    final t = row.techniqueNote?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }

  /// Raw text for the editor (may be empty; not null).
  Future<String> techniquesForEditor(String routineExerciseId) async {
    final row = await (_db.select(_db.routineExercises)
          ..where((e) => e.id.equals(routineExerciseId)))
        .getSingleOrNull();
    if (row == null) return '';
    return row.techniqueNote?.trim() ?? '';
  }

  Future<void> saveTechniques({
    required String routineExerciseId,
    required String text,
  }) async {
    final trimmed = text.trim();
    final updated = await (_db.update(_db.routineExercises)
          ..where((e) => e.id.equals(routineExerciseId)))
        .write(
      RoutineExercisesCompanion(
        techniqueNote: Value(trimmed.isEmpty ? null : trimmed),
      ),
    );
    if (updated == 0) {
      throw StateError('Routine exercise not found: $routineExerciseId');
    }
  }
}
