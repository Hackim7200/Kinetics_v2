import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';

/// Reads and updates technique notes on [Exercises] (Drift).
class ExerciseTechniquesService {
  ExerciseTechniquesService(this._db);

  final AppDatabase _db;

  Future<String?> storedTechniquesTrimmed(String exerciseId) async {
    final row = await (_db.select(_db.exercises)
          ..where((e) => e.id.equals(exerciseId)))
        .getSingleOrNull();
    if (row == null) return null;
    final t = row.techniques?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }

  /// Raw text for the editor (may be empty; not null).
  Future<String> techniquesForEditor(String exerciseId) async {
    final row = await (_db.select(_db.exercises)
          ..where((e) => e.id.equals(exerciseId)))
        .getSingleOrNull();
    if (row == null) return '';
    return row.techniques?.trim() ?? '';
  }

  Future<void> saveTechniques({
    required String exerciseId,
    required String text,
  }) async {
    final trimmed = text.trim();
    final updated = await (_db.update(_db.exercises)
          ..where((e) => e.id.equals(exerciseId)))
        .write(
      ExercisesCompanion(
        techniques: Value(trimmed.isEmpty ? null : trimmed),
      ),
    );
    if (updated == 0) {
      throw StateError('Exercise not found: $exerciseId');
    }
  }
}
