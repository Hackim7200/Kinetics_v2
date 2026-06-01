import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/workout_tables/routine_table.dart';

/// Exercise slot within a routine (`timer` or `weight`).
@DataClassName('RoutineExercise')
class RoutineExercises extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text().references(Routines, #id)();
  TextColumn get title => text()();
  IntColumn get targetSets => integer().nullable()();
  TextColumn get targetReps => text().nullable()();
  TextColumn get techniqueNote => text().nullable()();
  TextColumn get timerTarget => text().nullable()();
  IntColumn get orderIndex => integer()();
  TextColumn get type => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
