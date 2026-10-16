import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toursathi/data/models.dart';
import 'package:toursathi/main.dart';
import 'package:toursathi/services/store.dart';

void main() {
  test('distance between two nearby points is reasonable', () {
    final d = distanceKm(23.5400, 87.2890, 23.5580, 87.2840);
    expect(d, greaterThan(1.5));
    expect(d, lessThan(3));
  });

  test('bengali digits', () {
    expect(bn(2026), '২০২৬');
  });

  test('import admin json', () async {
    SharedPreferences.setMockInitialValues({});
    await store.load();
    final n = store.importJson(
        '{"pandals":[{"id":"a","name":"Test","area":"X","lat":23.5,"lng":87.3}],'
        '"schedule":[{"name":"ষষ্ঠী","date":"2026-10-16"}]}');
    expect(n, 1);
    expect(store.pandals.first.name, 'Test');
    expect(store.schedule.length, 1);
    store.resetToDemo();
    expect(store.usingDemo, true);
  });

  testWidgets('app renders home screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await store.load();
    await tester.pumpWidget(const TourSathiApp());
    expect(find.text('শুভ দুর্গাপূজা'), findsWidgets);
    await tester.pump(const Duration(seconds: 1));
  });
}
