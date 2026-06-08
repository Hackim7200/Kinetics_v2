const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Display helpers for routine UI.
abstract final class RoutineDisplay {
  /// Calendar label for a workout log instant (UTC → local).
  static String formatLastSessionDate(DateTime utc) {
    final local = utc.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    if (day == today) return 'TODAY';
    if (day == today.subtract(const Duration(days: 1))) {
      return 'YESTERDAY';
    }
    return '${_months[local.month - 1]} ${local.day}, ${local.year}';
  }

  /// User-facing label when there is no session yet.
  static String formatLastSessionLabel(DateTime? last) {
    return last == null ? 'NEVER' : formatLastSessionDate(last);
  }
}
