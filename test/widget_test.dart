// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:umbra/app/app.dart';
import 'package:umbra/di/locator.dart';

void main() {
  testWidgets('Counter increments via FAB', (WidgetTester tester) async {
    setupLocator();
    await tester.pumpWidget(const UmbraApp());

    expect(find.text('Counter (MVVM)'), findsOneWidget);
    expect(find.text('Count: 0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Count: 1'), findsOneWidget);
  });
}
