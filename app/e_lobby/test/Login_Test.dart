import 'package:e_lobby/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loginUsingEmailPasword should sign in user with correct credentials',
          () async {
        // Set up test dependencies
        await Firebase.initializeApp();
        final auth = FirebaseAuth.instance;

        // Create a new user for testing
        final email = 'test1@test1.com';
        final password = '123456789';
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Create the test widget
        final loginScreen = LoginScreenState();
        final context = MockBuildContext();
        final user = await LoginScreenState.loginUsingEmailPasword(
            email: email, password: password, context: context);

        // Verify that the user was signed in
        expect(user, isNotNull);
        expect(user!.email, email);
      });
}

// Define a mock BuildContext for testing
class MockBuildContext extends Fake implements BuildContext {}