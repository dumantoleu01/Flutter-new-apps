import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_with_tests/features/domain/usecase/get_current_weather.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_event.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_state.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;
  WeatherBloc(this._getCurrentWeatherUseCase) : super(WeatherInitialState()) {
    on<OnCityChanged>(
      (event, emit) async {
        emit(WeatherLoadingState());

        final result = await _getCurrentWeatherUseCase.execute(event.cityName);
        result.fold((failure) {
          emit(WeatherErrorState(failure.message));
        }, (data) {
          emit(WeatherLoadedState(data));
        });
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (event, mapper) => event.debounceTime(duration).flatMap(mapper);
}
