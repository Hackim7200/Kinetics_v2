import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mobile_frontend/database/tables/circuit_tables/circuit_exercise_table.dart';
import 'package:mobile_frontend/database/tables/circuit_tables/circuit_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/exercise_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/routine_exercise_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/routine_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/set_entry_table.dart';
import 'package:mobile_frontend/database/tables/workout_tables/workout_log_table.dart';

import 'package:path/path.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

// Drift database
@DriftDatabase(
  tables: [
    Routines,
    Exercises,
    RoutineExercises,
    Circuits,
    CircuitExercises,
    WorkoutLogs,
    SetEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  final Directory dbDirectory;
  final String sqliteFileName;

  AppDatabase({required this.dbDirectory, required this.sqliteFileName})
    : super(_openConnection(dbDirectory, sqliteFileName));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 4) {
        await m.database.customStatement('DROP TABLE IF EXISTS todo_table');
      }
      if (from < 3) {
        await m.database.customStatement('DROP TABLE IF EXISTS routine_table');
        await m.database.customStatement('DROP TABLE IF EXISTS routines');
        await m.createTable(routines);
        await m.createTable(exercises);
        await m.createTable(routineExercises);
        await m.createTable(circuits);
        await m.createTable(circuitExercises);
        await m.createTable(workoutLogs);
        await m.createTable(setEntries);
      }
    },
  );
}

LazyDatabase _openConnection(Directory dbDirectory, String sqliteFileName) {
  return LazyDatabase(() async {
    if (!await dbDirectory.exists()) {
      await dbDirectory.create(recursive: true);
    }

    final file = File(join(dbDirectory.path, sqliteFileName));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON');
        rawDb.execute('PRAGMA journal_mode = WAL');
        rawDb.execute('PRAGMA busy_timeout = 5000');
      },
    );
  });
}
