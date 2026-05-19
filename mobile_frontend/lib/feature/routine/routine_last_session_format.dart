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

/// Calendar label for a workout log instant (UTC → local).
String formatRoutineLastSessionDate(DateTime utc) {
  final d = utc.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  if (day == today) return 'TODAY';
  if (day == today.subtract(const Duration(days: 1))) {
    return 'YESTERDAY';
  }
  return '${_months[d.month - 1]} ${d.day}, ${d.year}';
}

/// User-facing label when there is no session yet.
String formatRoutineLastSessionLabel(DateTime? last) =>
    last == null ? 'NEVER' : formatRoutineLastSessionDate(last);
