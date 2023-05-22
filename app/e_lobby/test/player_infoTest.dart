import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_lobby/player_info.dart';

void main() {
  group('RankSelectionDialog', ()
  {
    testWidgets('should display title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: RankSelectionDialog(),
        ),
      ));

      // Act
      final titleFinder = find.text('Select a rank');

      // Assert
      expect(titleFinder, findsOneWidget);
    });
  });
}

