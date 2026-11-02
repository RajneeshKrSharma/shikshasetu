import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha_setu/app.dart';
import 'package:shiksha_setu/di/injector.dart';

import 'helpers/test_database.dart';

void main() {
  Future<void> settle(WidgetTester tester, {int rounds = 30}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 40)),
      );
      await tester.pump(const Duration(milliseconds: 40));
    }
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final f = find.text(text).first;
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester, rounds: 8);
  }

  testWidgets('the Principal builds a paper with an MCQ and approves it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await initializeDateFormatting();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final database = await tester.runAsync(openTestDatabase);
    await configureDependencies(database: database!, prefs: prefs);
    addTearDown(() => tester.runAsync(database.close));
    await tester.runAsync(() => database.db.insert('classes', {'name': '6-A'}));

    await tester.pumpWidget(const ShikshaSetuApp());
    await settle(tester);

    // Set up the school and get past the theme step.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Green Valley School');
    await tester.enterText(fields.at(1), 'Asha Rao');
    await tester.enterText(fields.at(2), 'asha@school.test');
    await tester.enterText(fields.at(3), '9876543210');
    await tester.enterText(fields.at(4), 'correct-horse');
    await tester.enterText(fields.at(5), 'correct-horse');
    await tester.tap(find.text('Create school'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    // Exams is in the drawer.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await settle(tester, rounds: 8);
    expect(find.text('Master questions'), findsNothing);
    await tester.tap(find.text('Exams').last);
    await settle(tester, rounds: 8);

    await tester.tap(find.text('Create paper'));
    await settle(tester, rounds: 8);

    // Details.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Paper title'),
      'Unit Test 1',
    );
    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<String>, 'Subject'),
    );
    await settle(tester, rounds: 6);
    await tester.tap(find.text('Mathematics').last);
    await settle(tester, rounds: 6);
    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<String>, 'Class'),
    );
    await settle(tester, rounds: 6);
    await tester.tap(find.text('6-A').last);
    await settle(tester, rounds: 6);

    // The starter question is a short answer.
    final questionField = find.widgetWithText(TextFormField, 'Question');
    await tester.enterText(questionField.first, 'Define force.');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Marks').first,
      '2',
    );

    // Add an MCQ.
    await tapText(tester, 'Add question');
    await tester.tap(find.text('Multiple choice').last);
    await settle(tester, rounds: 8);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Question').last,
      'Capital of India?',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Option A'),
      'Mumbai',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Option B'),
      'Delhi',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Marks').last,
      '1',
    );
    await settle(tester, rounds: 4);

    // Total marks follow.
    expect(find.textContaining('3'), findsWidgets);

    await tapText(tester, 'Approve and save');
    await settle(tester);

    // Back on Exams, the paper is in the Ready tab.
    expect(find.text('Exams'), findsWidgets);
    await tester.tap(find.text('Ready'));
    await settle(tester, rounds: 10);
    expect(find.text('Unit Test 1'), findsOneWidget);
    expect(find.text('Approved'), findsWidgets);

    // Its detail shows both questions, with the MCQ's options.
    await tester.tap(find.text('Unit Test 1'));
    await settle(tester, rounds: 10);
    expect(find.text('Define force.'), findsOneWidget);
    expect(find.text('Capital of India?'), findsOneWidget);
    expect(find.text('(b) Delhi'), findsOneWidget);
    expect(find.text('Edit paper'), findsOneWidget);
  });

  testWidgets(
    'a paper sent by a teacher is reviewed from Approvals, then approved',
    (tester) async {
      tester.view.physicalSize = const Size(900, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await initializeDateFormatting();
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final database = await tester.runAsync(openTestDatabase);
      await configureDependencies(database: database!, prefs: prefs);
      addTearDown(() => tester.runAsync(database.close));
      await tester.runAsync(() async {
        await database.db.insert('classes', {'name': '6-A'});
        await insertTeacher(database, 't1', name: 'Meena Joshi');
        await database.db.insert('exam_papers', {
          'id': 'p1',
          'title': 'Half-yearly Science',
          'subject': 'Science',
          'class_name': '6-A',
          'exam_date': DateTime(2026, 12, 1).millisecondsSinceEpoch,
          'duration_minutes': 90,
          'status': 'submitted',
          'created_by': 't1',
          'submitted_at': DateTime(2026, 10, 1).millisecondsSinceEpoch,
        });
        await database.db.insert('exam_questions', {
          'paper_id': 'p1',
          'position': 0,
          'text': 'Name the largest planet.',
          'marks': 2,
          'type': 'shortAnswer',
        });
      });

      await tester.pumpWidget(const ShikshaSetuApp());
      await settle(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Green Valley School');
      await tester.enterText(fields.at(1), 'Asha Rao');
      await tester.enterText(fields.at(2), 'asha@school.test');
      await tester.enterText(fields.at(3), '9876543210');
      await tester.enterText(fields.at(4), 'correct-horse');
      await tester.enterText(fields.at(5), 'correct-horse');
      await tester.tap(find.text('Create school'));
      await settle(tester);
      await tester.tap(find.text('Continue'));
      await settle(tester);

      // The dashboard tile counts it, and View opens Approvals.
      await tester.tap(find.text('View'));
      await settle(tester, rounds: 10);
      expect(find.text('Half-yearly Science'), findsOneWidget);
      expect(find.text('Review paper'), findsOneWidget);

      // Review shows the paper and the approve / send back choices.
      await tester.tap(find.text('Review paper'));
      await settle(tester, rounds: 10);
      expect(find.text('Waiting for your approval'), findsOneWidget);
      expect(find.text('Name the largest planet.'), findsOneWidget);
      expect(find.textContaining('Set by Meena Joshi'), findsOneWidget);

      // The newest screen is last; Approvals below it has its own Approve.
      await tester.tap(find.text('Approve').last);
      await settle(tester, rounds: 10);

      // Approved: the review banner goes and the paper can be printed.
      expect(find.text('Waiting for your approval'), findsNothing);
      expect(find.text('Approved'), findsWidgets);
      expect(find.text('Preview and print'), findsOneWidget);
    },
  );
}
