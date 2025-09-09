import 'package:flutter_test/flutter_test.dart';

import 'package:umbra/features/counter/data/counter_repository.dart';
import 'package:umbra/features/counter/presentation/counter_view_model.dart';

void main() {
  test('CounterViewModel increments counter', () {
    final repo = CounterRepository();
    final vm = CounterViewModel(counterRepository: repo);

    expect(vm.counter.value, 0);
    vm.increment();
    expect(vm.counter.value, 1);
  });
}
