/// Domain model for a circuit configuration. Drift-free.
class Circuit {
  final String id;
  final String title;
  final String order;
  final int? rest;
  final int? rounds;
  final int? countdown;
  final int? stationDuration;

  const Circuit({
    required this.id,
    required this.title,
    required this.order,
    this.rest,
    this.rounds,
    this.countdown,
    this.stationDuration,
  });

  bool get isRandomised => order == 'randomised';

  static String orderFromRandomized(bool randomizeStationOrder) {
    return randomizeStationOrder ? 'randomised' : 'sequential';
  }

  Circuit copyWith({
    String? id,
    String? title,
    String? order,
    int? rest,
    int? rounds,
    int? countdown,
    int? stationDuration,
  }) {
    return Circuit(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      rest: rest ?? this.rest,
      rounds: rounds ?? this.rounds,
      countdown: countdown ?? this.countdown,
      stationDuration: stationDuration ?? this.stationDuration,
    );
  }
}
