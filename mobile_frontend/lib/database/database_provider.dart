import 'package:mobile_frontend/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// App-wide Drift database. Overridden in [ProviderScope] after async init in `main`.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  throw StateError(
    'appDatabaseProvider must be overridden in ProviderScope before use.',
  );
}
