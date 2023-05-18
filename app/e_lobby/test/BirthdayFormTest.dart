import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_lobby/BirthdayForm.dart';

void main() {
  testWidgets('Select date and verify selected date text', (WidgetTester tester) async {
    DateTime? selectedDate;

    // Build the widget
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

  testWidgets('Select date and verify callback', (WidgetTester tester) async {
    DateTime? selectedDate;

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: BirthdayForm(
        onBirthdaySelected: (DateTime date) {
          selectedDate = date;
        },
      ),
    ));

    // Tap the select button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Select a date from the date picker
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify the selected date callback was called
    expect(selectedDate, isNotNull);
  });
}
