import 'dart:io';

import 'package:weather_app_with_tests/core/error/failure.dart';
import 'package:weather_app_with_tests/data/data_sources/remote_data_source.dart';
import 'package:weather_app_with_tests/domain/entities/weather.dart';
import 'package:weather_app_with_tests/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/exception.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName) async {
    try {
      final result = await weatherRemoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure('An error has occurred'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
