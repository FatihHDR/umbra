import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Simple language notifier: stores 'en' or 'id'. Default is English.
class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _load();
  }

  static const _boxName = 'prefs';
  static const _key = 'language';

  Future<void> _load() async {
    try {
      final box = await Hive.openBox(_boxName);
      final saved = box.get(_key) as String?;
      if (saved == 'en' || saved == 'id') {
        state = saved as String;
      }
    } catch (_) {}
  }

  Future<void> setLanguage(String code) async {
    if (code != 'en' && code != 'id') return;
    state = code;
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_key, code);
    } catch (_) {}
  }

  Locale get locale => Locale(state);
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) => LanguageNotifier());