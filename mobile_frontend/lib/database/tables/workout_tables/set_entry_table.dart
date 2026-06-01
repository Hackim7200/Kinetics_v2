import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/workout_tables/workout_log_table.dart';

@DataClassName('SetEntry')
class SetEntries extends Table {
  TextColumn get id => text()();
  TextColumn get workoutLogId => text().references(WorkoutLogs, #id)();
  IntColumn get setNumber => integer()();
  IntColumn get reps => integer().nullable()();
  IntColumn get timeElapsed => integer().nullable()();
  RealColumn get weight => real().nullable()();
  RealColumn get trainingLoad => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
