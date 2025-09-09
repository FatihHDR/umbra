import 'package:get_it/get_it.dart';

import '../features/counter/data/counter_repository.dart';
import '../features/counter/presentation/counter_view_model.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Repositories
  getIt.registerLazySingleton<CounterRepository>(() => CounterRepository());

  // ViewModels
  getIt.registerFactory<CounterViewModel>(() =>
      CounterViewModel(counterRepository: getIt<CounterRepository>()));
}
