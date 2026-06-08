import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_notifier.g.dart';

/// In-memory counter used as a Riverpod example. No persistence layer.
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;

  void increment() {
    state = state + 1;
  }

  void decrement() {
    state = state - 1;
  }

  void reset() {
    state = 0;
  }
}
