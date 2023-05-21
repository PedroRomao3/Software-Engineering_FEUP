import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CustomUser {
  String name;

  CustomUser(this.name);
}

class TestFirebase extends StatefulWidget {
  final CustomUser user;

  const TestFirebase(this.user, {Key? key}) : super(key: key);

  @override
  _TestFirebaseState createState() => _TestFirebaseState();
}

class _TestFirebaseState extends State<TestFirebase> {
  bool isDataLoaded = false;

  Future<void> loadData() async {
    // Simulating an asynchronous data loading process
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  testWidgets('Acceptance Test - TestFirebase', (WidgetTester tester) async {
    // Given
    var user = CustomUser("Alice");

    // When
    await tester.pumpWidget(TestFirebase(user));

    // Wait for data loading to complete
    await tester.pump(const Duration(seconds: 2));

    // Then
    var testFirebaseState = tester.state<_TestFirebaseState>(find.byType(TestFirebase));
    expect(testFirebaseState.isDataLoaded, isTrue);
  });


}







