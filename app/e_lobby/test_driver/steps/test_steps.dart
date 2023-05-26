import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
class CheckGivenWidgets
    extends Given3WithWorld<String,String,String,FlutterWorld> {
  @override
  Future<void> executeStep(String input1, String input2, String input3) async {
// TODO: implement executeStep
    final textinput1 = find.byValueKey(input1);
    final textinput2 = find.byValueKey(input2);
    final button = find.byValueKey(input3);
    bool input1Exists = await FlutterDriverUtils.isPresent(world.driver, textinput1);
    bool input2Exists = await FlutterDriverUtils.isPresent(world.driver,textinput2);
    bool buttonExists = await FlutterDriverUtils.isPresent(world.driver, button);
    expect(input1Exists, true);
    expect(input2Exists, true);
    expect(buttonExists, true);
  }
@override
// TODO: implement pattern
RegExp get pattern => RegExp(r"I have {string} and {string} and {string}");
}

class FillEmail extends When2WithWorld<String,String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1, String input2) async {
// TODO: implement executeStep

    final textinput1 = find.byValueKey(input1);


    await FlutterDriverUtils.enterText(world.driver, textinput1, input2);
  }
  @override
  RegExp get pattern => RegExp(r"I fill {string} with {string}");
}

class ClickLoginButton extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String loginbtn) async {
// TODO: implement executeStep
    final loginfinder = find.byValueKey(loginbtn);
    await FlutterDriverUtils.tap(world.driver, loginfinder);
  }
  @override
  RegExp get pattern => RegExp(r"I tap the {string} button");
}

class Checkpage extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
// TODO: implement executeStep

    final pagefinder = find.byValueKey(input1);
    bool pageExists = await FlutterDriverUtils.isPresent(world.driver, pagefinder);
    expect(pageExists, true);

    await FlutterDriverUtils.isPresent(world.driver, pagefinder);
  }
  @override
  RegExp get pattern => RegExp(r"I should have {string} on screen");
}