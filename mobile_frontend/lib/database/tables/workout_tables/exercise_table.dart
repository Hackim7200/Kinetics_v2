import 'package:drift/drift.dart';

@DataClassName('Exercise')
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get muscleGroup => text().nullable()();
  TextColumn get techniques => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
