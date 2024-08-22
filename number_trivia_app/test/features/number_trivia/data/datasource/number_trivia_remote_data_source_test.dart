import 'dart:convert';
import 'dart:html';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_app/core/error/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(String url) {
    when(mockHttpClient.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    )).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(String url) {
    when(mockHttpClient.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    )).thenAnswer((_) async => http.Response('Somethin went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final url = 'http://numbersapi.com/$tNumber';
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''should perform a GET request on a URL with number
            being the endpoint and with application/json header''',
      () async {
        setUpMockHttpClientSuccess200(url);

        dataSource.getConcreateNumberTrivia(tNumber);
        verify(mockHttpClient.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      setUpMockHttpClientSuccess200(url);

      final result = dataSource.getConcreateNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      setUpMockHttpClientFailure404(url);

      final result = dataSource.getConcreateNumberTrivia;

      expect(() => result(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    const url = 'http://numbersapi.com/random';
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''should perform a GET request on a URL with number
            being the endpoint and with application/json header''',
      () async {
        setUpMockHttpClientSuccess200(url);

        dataSource.getRandomNumberTrivia;
        verify(mockHttpClient.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      setUpMockHttpClientSuccess200(url);

      final result = dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      setUpMockHttpClientFailure404(url);

      final result = dataSource.getRandomNumberTrivia;

      expect(() => result(), throwsA(isA<ServerException>()));
    });
  });
}
