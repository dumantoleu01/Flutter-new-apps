import 'dart:io';

import 'package:weather_app_with_tests/core/error/exception.dart';
import 'package:weather_app_with_tests/features/data/datasource/remote_data_source.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';
import 'package:weather_app_with_tests/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app_with_tests/features/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatheRemoteDataSource weatheRemoteDataSource;

  WeatherRepositoryImpl({required this.weatheRemoteDataSource});
  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName) async {
    try {
      final result = await weatheRemoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure('An error has occured.'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
