import 'package:dartz/dartz.dart';
import 'package:weather_app_with_tests/core/error/failure.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';
import 'package:weather_app_with_tests/features/domain/repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository _weatherRepository;

  const GetCurrentWeatherUseCase(this._weatherRepository);

  Future<Either<Failure, WeatherEntity>> execute(String cityName) {
    return _weatherRepository.getCurrentWeather(cityName);
  }
}
