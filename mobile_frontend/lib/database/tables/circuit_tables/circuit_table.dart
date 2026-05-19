import 'package:drift/drift.dart';

@DataClassName('Circuit')
class Circuits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get rounds => integer().nullable()();
  IntColumn get stationDurationSeconds => integer().nullable()();
  IntColumn get preStartCountdownSeconds => integer().nullable()();
  IntColumn get restBetweenRoundsSeconds => integer().nullable()();
  BoolColumn get randomizeStationOrder => boolean().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
