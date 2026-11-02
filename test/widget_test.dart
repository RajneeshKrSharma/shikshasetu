import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha_setu/app.dart';
import 'package:shiksha_setu/di/injector.dart';

import 'helpers/test_database.dart';

void main() {
  /// Database replies arrive in real time, but what follows each reply only
  /// runs on a pump. So alternate the two until nothing is left in flight.
  Future<void> settle(WidgetTester tester, {int rounds = 40}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)),
      );
      await tester.pump(const Duration(milliseconds: 60));
    }
  }

  testWidgets('first launch: set up the school, land on the dashboard, '
      'sign out and sign back in', (tester) async {
    await initializeDateFormatting();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final database = await tester.runAsync(openTestDatabase);
    await configureDependencies(database: database!, prefs: prefs);
    addTearDown(() => tester.runAsync(database.close));

    await tester.pumpWidget(const ShikshaSetuApp());
    await settle(tester);

    // No account exists yet, so the setup screen is shown.
    expect(find.text('Set up your school'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Green Valley School');
    await tester.enterText(fields.at(1), 'Asha Rao');
    await tester.enterText(fields.at(2), 'asha@school.test');
    await tester.enterText(fields.at(3), '9876543210');
    await tester.enterText(fields.at(4), 'correct-horse');
    await tester.enterText(fields.at(5), 'correct-horse');
    await tester.ensureVisible(find.text('Create school'));
    await tester.tap(find.text('Create school'));
    await settle(tester);

    // First-run theme step comes before the app.
    expect(find.text('Theme color'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    // Signed in as the Principal.
    expect(find.textContaining(', Asha'), findsWidgets);
    expect(find.text('Dashboard'), findsWidgets);

    // Sign out from the Profile tab.
    await tester.tap(find.text('Profile'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.scrollUntilVisible(
      find.text('Sign Out'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Sign Out'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Welcome back'), findsOneWidget);

    // Wrong password is rejected, the right one signs in again.
    final login = find.byType(TextFormField);
    await tester.enterText(login.at(0), 'asha@school.test');
    await tester.enterText(login.at(1), 'wrong-password');
    await tester.tap(find.text('Sign In'));
    await settle(tester);
    expect(find.text('Invalid email or password'), findsOneWidget);

    await tester.enterText(login.at(1), 'correct-horse');
    await tester.tap(find.text('Sign In'));
    await settle(tester);
    expect(find.textContaining(', Asha'), findsWidgets);
  });
}
