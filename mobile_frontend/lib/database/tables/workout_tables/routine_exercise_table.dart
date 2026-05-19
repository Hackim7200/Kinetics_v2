import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/workout_tables/exercise_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/routine_table.dart';

@DataClassName('RoutineExercise')
class RoutineExercises extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text().references(Routines, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get orderIndex => integer()();
  IntColumn get targetSets => integer().nullable()();
  TextColumn get targetReps => text().nullable()();
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get timerTarget => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
