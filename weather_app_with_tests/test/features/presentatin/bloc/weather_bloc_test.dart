import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_with_tests/core/error/failure.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_event.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_state.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
  });

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

  test('initial bloc should be empthy', () {
    expect(weatherBloc.state, WeatherInitialState());
  });

  blocTest<WeatherBloc, WeatherState>(
    'should emit [WeatherLoadingState, WeatherLoadedState] when data is gotten successfully.',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName)).thenAnswer((_) async => const Right(testWeatherEntity));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoadingState(),
      const WeatherLoadedState(testWeatherEntity),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit [WeatherLoadingState, WeatherErrorState] when get data is unsuccessfully.',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName)).thenAnswer((_) async => const Left(ServerFailure('An error has occured.')));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoadingState(),
      const WeatherErrorState('An error has occured.'),
    ],
  );
}
