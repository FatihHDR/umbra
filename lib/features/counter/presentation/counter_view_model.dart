import '../../../core/base_view_model.dart';
import '../data/counter_repository.dart';
import '../domain/counter.dart';

class CounterViewModel extends BaseViewModel {
  CounterViewModel({required CounterRepository counterRepository})
      : _repo = counterRepository;

  final CounterRepository _repo;

  Counter get counter => _repo.current;

  void increment() {
    setBusy();
    _repo.increment();
    setIdle();
  }

  void reset() {
    setBusy();
    _repo.reset();
    setIdle();
  }
}
