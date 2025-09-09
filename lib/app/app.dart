import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../di/locator.dart';
import '../features/counter/presentation/counter_screen.dart';
import '../features/counter/presentation/counter_view_model.dart';

class UmbraApp extends StatelessWidget {
  const UmbraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<CounterViewModel>()),
      ],
      child: MaterialApp(
        title: 'Umbra',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CounterScreen(),
      ),
    );
  }
}
