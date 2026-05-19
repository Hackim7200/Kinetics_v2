import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/workout_tables/routine_exercise_table.dart';

@DataClassName('WorkoutLog')
class WorkoutLogs extends Table {
  TextColumn get id => text()();
  TextColumn get routineExerciseId =>
      text().references(RoutineExercises, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  RealColumn get trainingLoadChangePercent => real().nullable()();
  RealColumn get totalTrainingLoad => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
