// feature/counter/provider/counter_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
// This part directive tells the generator where to put the generated code
part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    // This is your initial state
    return 0;
  }

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
