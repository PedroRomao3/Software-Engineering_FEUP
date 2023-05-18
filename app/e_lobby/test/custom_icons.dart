import 'package:e_lobby/custom_icons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verify custom icons', () {
    expect(CustomIcons.icons8_counter_strike.codePoint, 0xe803);
    expect(CustomIcons.icons8_counter_strike.fontFamily, 'CustomIcons');
    expect(CustomIcons.icons8_counter_strike.fontPackage, null);

    expect(CustomIcons.icons8_league_of_legends__1_.codePoint, 0xe804);
    expect(CustomIcons.icons8_league_of_legends__1_.fontFamily, 'CustomIcons');
    expect(CustomIcons.icons8_league_of_legends__1_.fontPackage, null);
  });

  test('Verify custom icon list', () {
    expect(CustomIcons.customIconList, containsAll([CustomIcons.icons8_counter_strike, CustomIcons.icons8_league_of_legends__1_]));
  });
}
