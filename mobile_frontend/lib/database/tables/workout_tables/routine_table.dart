import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/tables/sync_metadata_mixin.dart';

@DataClassName('Routine')
class Routines extends Table with SyncMetadataColumns {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
