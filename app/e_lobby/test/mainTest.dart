import 'package:e_lobby/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('LoginScreen', () {
    testWidgets('Login screen UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.text('Login to E_LobBy '), findsOneWidget);
      expect(find.widgetWithText(TextField, 'User Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'User Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.widgetWithText(RawMaterialButton, 'Login'), findsOneWidget);
      expect(find.widgetWithText(RawMaterialButton, 'Register'), findsOneWidget);
    });

    testWidgets('Login screen - Tap on Forgot Password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('SEND EMAIL'), findsOneWidget);
    });
  });

}

