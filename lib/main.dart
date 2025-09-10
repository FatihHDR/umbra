import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp();

  // Load env (expects a .env file at project root)
  await dotenv.load(fileName: ".env", isOptional: true);

  // Init Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('conversations');
  await Hive.openBox('prefs');

  runApp(const ProviderScope(child: UmbraApp()));
}
