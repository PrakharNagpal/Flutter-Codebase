import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  final homeTabIconFinder = find.byValueKey('home_tab_icon');
  late FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    driver.close();
  });

  test('Navigation icons are visible and clickable', () async {
    await driver.tap(homeTabIconFinder);
  });
}
