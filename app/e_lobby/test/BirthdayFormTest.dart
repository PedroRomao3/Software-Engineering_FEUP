import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_lobby/BirthdayForm.dart';

void main() {
  // Unit test: Selecting a date updates the selected date
  testWidgets('Selecting a date updates the selected date', (WidgetTester tester) async {
    DateTime? selectedDate;

    await tester.pumpWidget(MaterialApp(
      home: BirthdayForm(
        onBirthdaySelected: (DateTime date) {
          selectedDate = date;
        },
      ),
    ));

    // Verify initial state
    expect(selectedDate, isNull);

    // Tap the select button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Select a date from the date picker
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify the selected date is updated
    expect(selectedDate, isNotNull);
    expect(selectedDate, isNot(DateTime.now()));
  });

  // Unit test: BirthdayForm selects and passes the chosen date
  testWidgets('BirthdayForm selects and passes the chosen date', (WidgetTester tester) async {
    DateTime? selectedDate;

    await tester.pumpWidget(MaterialApp(
      home: BirthdayForm(
        onBirthdaySelected: (date) {
          selectedDate = date;
        },
      ),
    ));

    // Verify initial state
    expect(find.text('Selected date:'), findsNothing);

    // Tap the select button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Select a date from the date picker
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify the selected date is updated
    expect(selectedDate, isNotNull);
    expect(selectedDate, isNot(DateTime.now()));

    // Verify the selected date text is displayed
    expect(find.text('Selected date: ${selectedDate!.toString()}'), findsOneWidget);
  });

  // Unit test: BirthdayForm constructor sets onBirthdaySelected function
  test('BirthdayForm constructor sets onBirthdaySelected function', () {
    bool callbackCalled = false;
    void onBirthdaySelectedCallback(DateTime date) {
      callbackCalled = true;
    }

    final form = BirthdayForm(onBirthdaySelected: onBirthdaySelectedCallback);

    expect(form.onBirthdaySelected, equals(onBirthdaySelectedCallback));
    expect(callbackCalled, isFalse);
  });

  // Acceptance test: Select date and verify selected date text
  testWidgets('Select date and verify selected date text', (WidgetTester tester) async {
    DateTime? selectedDate;

    await tester.pumpWidget(MaterialApp(
      home: BirthdayForm(
        onBirthdaySelected: (DateTime date) {
          selectedDate = date;
        },
      ),
    ));

    // Verify initial state
    expect(find.text('Selected date:'), findsNothing);

    // Tap the select button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Select a date from the date picker
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify the selected date text is displayed
    expect(find.text('Selected date: ${selectedDate.toString()}'), findsOneWidget);
  });

  // Acceptance test: Selecting a date updates the selected date
  testWidgets('Selecting a date updates the selected date', (WidgetTester tester) async {
    late DateTime selectedDate;

    final widget = BirthdayForm(
      onBirthdaySelected: (date) {
        selectedDate = date;
      },
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final datePickerDialog = find.byType(DatePickerDialog);
    expect(datePickerDialog, findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(selectedDate, isNotNull);
    expect(selectedDate, isNot(DateTime.now()));

  });
}


