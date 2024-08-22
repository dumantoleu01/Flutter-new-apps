import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entety',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTriviaModel>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return valid model when the JSON number is an integer',
        () async {
          final Map<String, dynamic> fromJson = json.decode(fixture('trivia.json'));
          final result = NumberTriviaModel.fromJson(fromJson);
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
        'should return valid model when the JSON number is regarded as a double',
        () async {
          final Map<String, dynamic> fromJson = json.decode(fixture('trivia_double.json'));
          final result = NumberTriviaModel.fromJson(fromJson);
          expect(result, equals(tNumberTriviaModel));
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          final result = tNumberTriviaModel.toJson();
          final expectResult = {
            'text': 'Test Text',
            'number': 1,
          };
          expect(result, expectResult);
        },
      );
    },
  );
}
