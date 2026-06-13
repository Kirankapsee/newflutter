import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practise/main.dart';

void main() {
  setUp(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(1400, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
  });

  tearDown(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  testWidgets('Shows left drawer destinations', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Navigation'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Navigates to settings route from drawer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Configure app preferences for web.'), findsOneWidget);
  });
}
