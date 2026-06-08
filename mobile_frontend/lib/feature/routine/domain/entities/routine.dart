/// Domain model for a workout routine. Drift-free.
class Routine {
  final String id;
  final String title;
  final String? description;

  const Routine({
    required this.id,
    required this.title,
    this.description,
  });

  Routine copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Routine(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
