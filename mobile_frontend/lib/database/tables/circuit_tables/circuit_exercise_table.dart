import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/circuit_tables/circuit_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/exercise_table.dart';

@DataClassName('CircuitExercise')
class CircuitExercises extends Table {
  TextColumn get id => text()();
  TextColumn get circuitId => text().references(Circuits, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
