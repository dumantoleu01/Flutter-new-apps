import 'package:equatable/equatable.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final WeatherEntity result;
  const WeatherLoadedState(this.result);

  @override
  List<Object> get props => [result];
}

class WeatherErrorState extends WeatherState {
  final String message;

  const WeatherErrorState(this.message);

  @override
  List<Object> get props => [message];
}
