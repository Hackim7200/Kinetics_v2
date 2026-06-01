import 'package:drift/drift.dart';

/// `order` is `sequential` or `randomised`.
@DataClassName('Circuit')
class Circuits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get order => text()();
  IntColumn get rest => integer().nullable()();
  IntColumn get rounds => integer().nullable()();
  IntColumn get countdown => integer().nullable()();
  IntColumn get stationDuration => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
