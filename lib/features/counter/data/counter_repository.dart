import '../domain/counter.dart';

class CounterRepository {
  Counter _counter = const Counter(0);

  Counter get current => _counter;

  Counter increment() {
    _counter = Counter(_counter.value + 1);
    return _counter;
  }

  void reset() {
    _counter = const Counter(0);
  }
}
