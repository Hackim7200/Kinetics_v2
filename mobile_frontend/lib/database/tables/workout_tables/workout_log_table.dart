import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/sync_metadata_mixin.dart';
import 'package:mobile_frontend/database/tables/workout_tables/routine_exercise_table.dart';

@DataClassName('WorkoutLog')
class WorkoutLogs extends Table with SyncMetadataColumns {
  TextColumn get id => text()();
  TextColumn get exerciseId => text().references(RoutineExercises, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalTrainingLoad => real().nullable()(); //for graph

  @override
  Set<Column<Object>> get primaryKey => {id};
}
