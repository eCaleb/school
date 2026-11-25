import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:school/home.dart';
import 'package:school/main.dart' as app;

/// Pumps frames until [condition] is true. Password hashing runs on a
/// background isolate, so pumpAndSettle alone can return too early.
Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TestFailure('Timed out after $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await tester.pump();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end tests', () {
    testWidgets('register a new account, then log in with it', (tester) async {
      // Dummy test data. A new matric number each run, because the app
      // refuses to register the same one twice.
      final matricNumber =
          'bu${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}';
      const password = 'computer123';

      app.main();
      await tester.pumpAndSettle();

      // Register
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), matricNumber);
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await pumpUntil(
        tester,
        () => find.byType(app.RegisterPage).evaluate().isEmpty,
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).at(0), matricNumber);
      await tester.enterText(find.byType(TextFormField).at(1), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await pumpUntil(
        tester,
        () => find.byType(HomePage).evaluate().isNotEmpty,
      );
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('a wrong password is rejected', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'bu00000000x');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass1');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await pumpUntil(
        tester,
        () => find
            .text('Incorrect matric number or password.')
            .evaluate()
            .isNotEmpty,
      );
      expect(find.byType(HomePage), findsNothing);
    });
  });
}
