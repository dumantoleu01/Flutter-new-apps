import 'package:dartz/dartz.dart';
import 'package:weather_app_with_tests/core/error/failure.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName);
}
