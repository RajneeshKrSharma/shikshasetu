import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/attendance/domain/usecases/haversine.dart';

void main() {
  test('distanceMeters: same point → 0', () {
    expect(distanceMeters(12.9716, 77.5946, 12.9716, 77.5946), 0);
  });

  test(
    'distanceMeters: one degree of longitude on the equator ≈ 111.19 km',
    () {
      expect(distanceMeters(0, 0, 0, 1), closeTo(111195, 100));
    },
  );

  test('distanceMeters: about 100 m north of a point', () {
    // 0.0009° of latitude is roughly 100 m.
    expect(distanceMeters(12.0, 77.0, 12.0009, 77.0), closeTo(100, 1));
  });

  test('distanceMeters: order of the two points does not matter', () {
    expect(
      distanceMeters(10, 20, 11, 21),
      closeTo(distanceMeters(11, 21, 10, 20), 0.001),
    );
  });
}
