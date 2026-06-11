import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mobile_frontend/database/tables/circuit_tables/circuit_exercise_table.dart';
import 'package:mobile_frontend/database/tables/circuit_tables/circuit_table.dart';
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
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(workoutLogs, workoutLogs.totalTrainingLoad);
      }
      if (from < 4 && from >= 3) {
        await m.dropColumn(workoutLogs, 'training_load_change_percent');
      }
      if (from < 5) {
        await m.addColumn(routines, routines.version);
        await m.addColumn(routines, routines.updatedAt);
        await m.addColumn(routines, routines.createdAt);
        await m.addColumn(routines, routines.isDeleted);
        await m.addColumn(routines, routines.syncStatus);

        await m.addColumn(routineExercises, routineExercises.version);
        await m.addColumn(routineExercises, routineExercises.updatedAt);
        await m.addColumn(routineExercises, routineExercises.createdAt);
        await m.addColumn(routineExercises, routineExercises.isDeleted);
        await m.addColumn(routineExercises, routineExercises.syncStatus);

        await m.addColumn(circuits, circuits.version);
        await m.addColumn(circuits, circuits.updatedAt);
        await m.addColumn(circuits, circuits.createdAt);
        await m.addColumn(circuits, circuits.isDeleted);
        await m.addColumn(circuits, circuits.syncStatus);

        await m.addColumn(circuitExercises, circuitExercises.version);
        await m.addColumn(circuitExercises, circuitExercises.updatedAt);
        await m.addColumn(circuitExercises, circuitExercises.createdAt);
        await m.addColumn(circuitExercises, circuitExercises.isDeleted);
        await m.addColumn(circuitExercises, circuitExercises.syncStatus);

        await m.addColumn(workoutLogs, workoutLogs.version);
        await m.addColumn(workoutLogs, workoutLogs.updatedAt);
        await m.addColumn(workoutLogs, workoutLogs.createdAt);
        await m.addColumn(workoutLogs, workoutLogs.isDeleted);
        await m.addColumn(workoutLogs, workoutLogs.syncStatus);

        await m.addColumn(setEntries, setEntries.version);
        await m.addColumn(setEntries, setEntries.updatedAt);
        await m.addColumn(setEntries, setEntries.createdAt);
        await m.addColumn(setEntries, setEntries.isDeleted);
        await m.addColumn(setEntries, setEntries.syncStatus);
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
