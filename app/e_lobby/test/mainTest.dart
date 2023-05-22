import 'package:e_lobby/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen', () {
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

  test('createUserWithEmailAndPassword should create a user account', () async {
    final loginScreenState = LoginScreenState();
    const email = 'test@example.com';
    const password = 'password';

    await loginScreenState.createUserWithEmailAndPassword(email, password);
  });

  testWidgets('MyApp acceptance test', (WidgetTester tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(const MyApp());

    // Verify that the MaterialApp widget is rendered
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that the home property is set to the HomePage widget
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('HomePage acceptance test', (WidgetTester tester) async {
    // Build the HomePage widget
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Verify that the HomePage widget is rendered
    expect(find.byType(HomePage), findsOneWidget);

  });


}





