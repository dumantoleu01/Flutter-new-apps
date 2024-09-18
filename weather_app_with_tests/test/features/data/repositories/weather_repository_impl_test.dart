import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_with_tests/core/error/exception.dart';
import 'package:weather_app_with_tests/core/error/failure.dart';
import 'package:weather_app_with_tests/features/data/models/weather_model.dart';
import 'package:weather_app_with_tests/features/data/repositories/weather_repository_impl.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late WeatherRepositoryImpl weatherRepositoryImpl;
  late MockWeatheRemoteDataSource mockWeatheRemoteDataSource;

  setUp(() {
    mockWeatheRemoteDataSource = MockWeatheRemoteDataSource();
    weatherRepositoryImpl = WeatherRepositoryImpl(weatheRemoteDataSource: mockWeatheRemoteDataSource);
  });

  const testWeatherModel = WeatherModel(
    cityName: 'Nur-Sultan',
    main: 'Clear',
    description: 'clear sky',
    iconCode: "01n",
    temperature: 274.12,
    pressure: 1033,
    humidity: 86,
  );

  const testWeatherEntity = WeatherEntity(
    cityName: 'Nur-Sultan',
    main: 'Clear',
    description: 'clear sky',
    iconCode: "01n",
    temperature: 274.12,
    pressure: 1033,
    humidity: 86,
  );

  const testCityName = 'Nur-Sultan';

  group('get current weather', () {
    test('should return current weather when a call to data source is successefull', () async {
      when(mockWeatheRemoteDataSource.getCurrentWeather(testCityName)).thenAnswer((_) async => testWeatherModel);

      final result = await weatherRepositoryImpl.getCurrentWeather(testCityName);

      expect(result, equals(const Right(testWeatherEntity)));
    });

    test('should return server failure when a call to data source is unsuccessefull', () async {
      when(mockWeatheRemoteDataSource.getCurrentWeather(testCityName)).thenThrow(ServerException());

      final result = await weatherRepositoryImpl.getCurrentWeather(testCityName);

      expect(result, equals(const Left(ServerFailure('An error has occured.'))));
    });

    test('should return connection failure when the device has no internet', () async {
      when(mockWeatheRemoteDataSource.getCurrentWeather(testCityName)).thenThrow(const SocketException('Failed to connect to the network'));

      final result = await weatherRepositoryImpl.getCurrentWeather(testCityName);

      expect(result, equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
}
