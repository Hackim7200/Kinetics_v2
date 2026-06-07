import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';

bool timerSetHasDuration(Set setEntry) {
  final seconds = setEntry.timeElapsed;
  return seconds != null && seconds > 0;
}

/// Every set slot `1..maxSets` has exactly one row with a logged duration.
bool timerSessionLooksComplete(List<Set> sets, int maxSets) {
  for (var setNumber = 1; setNumber <= maxSets; setNumber++) {
    final rowsForSet = sets
        .where((setEntry) => setEntry.setNumber == setNumber)
        .toList();
    if (rowsForSet.length != 1) return false;
    if (!timerSetHasDuration(rowsForSet.single)) return false;
  }
  return true;
}
