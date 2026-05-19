import 'package:drift/drift.dart';

@DataClassName('Routine')
class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get estimatedDurationMinutes => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
