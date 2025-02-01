import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:school/home.dart';
import 'package:school/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end tests', () {
    (testWidgets('verify login screen with correct matric number and password',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();
      Future.delayed(Duration(seconds: 2));
      await tester.enterText(find.byType(TextFormField).at(0), 'bu20cit1080');
      Future.delayed(Duration(seconds: 2));
      await tester.enterText(find.byType(TextFormField).at(1), 'computer123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    }));
  });
}
