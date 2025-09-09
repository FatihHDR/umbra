// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:umbra/app/app.dart';

void main() {
  testWidgets('Umbra app shows HomeScreen', (tester) async {
    // Ensure Hive box exists for tests
    PathProviderPlatform.instance = PathProviderWindows();
    Hive.init('.dart_tool/test_hive');
    await Hive.openBox('conversations');
    await tester.pumpWidget(const ProviderScope(child: UmbraApp()));
    expect(find.text('Umbra'), findsOneWidget);
  });
}
