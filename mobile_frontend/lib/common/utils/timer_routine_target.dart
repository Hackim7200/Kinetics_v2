/// Timer exercise direction stored on [RoutineExercise.timerTarget].
abstract final class TimerRoutineTarget {
  static const increase = 'increase';
  static const decrease = 'decrease';

  static bool isValid(String? value) =>
      value == increase || value == decrease;

  static String label(String? value) {
    if (value == decrease) return 'Decrease';
    return 'Increase';
  }
}
