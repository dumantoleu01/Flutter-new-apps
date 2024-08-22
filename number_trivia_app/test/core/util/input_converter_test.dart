import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedString', () {
    test('should retern an integer when string represents an unsigned integer', () async {
      final str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(123));
    });

    test('should retern a failure when string is not an integer', () async {
      final str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Left(InvalidInputFailure));
    });

    test('should retern a failure when string is a negative integer', () async {
      final str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Left(InvalidInputFailure));
    });
  });
}
