import 'package:fair_go/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phone', () {
    expect(Validators.phone(''), isNotNull);
    expect(Validators.phone('12345'), isNotNull);
    expect(Validators.phone('5876543210'), isNotNull);
    expect(Validators.phone('98765 43210'), isNull);
  });

  test('otp', () {
    expect(Validators.otp('12345'), isNotNull);
    expect(Validators.otp('123456'), isNull);
  });

  test('name and optional email', () {
    expect(Validators.name(' '), isNotNull);
    expect(Validators.name('Rahul Sharma'), isNull);
    expect(Validators.optionalEmail(''), isNull);
    expect(Validators.optionalEmail('bad'), isNotNull);
    expect(Validators.optionalEmail('a@b.co'), isNull);
  });
}
