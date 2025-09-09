import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_view_model.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CounterViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Counter (MVVM)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('State: ${vm.state.name}'),
            const SizedBox(height: 12),
            Text('Count: ${vm.counter.value}',
                style: Theme.of(context).textTheme.headlineMedium),
            if (vm.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: context.read<CounterViewModel>().increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: context.read<CounterViewModel>().reset,
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
