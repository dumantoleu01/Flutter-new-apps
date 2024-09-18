import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';
import 'package:weather_app_with_tests/features/domain/usecase/get_current_weather.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });

  const testWeatherDetail = WeatherEntity(
    cityName: 'Astana',
    main: 'Clouds',
    description: 'few c;ouds',
    iconCode: "02d",
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const testCityName = "Astana";

  test(
    'should  get current weather detail from the repository',
    () async {
      when(mockWeatherRepository.getCurrentWeather(testCityName)).thenAnswer(
        (_) async => (const Right(testWeatherDetail)),
      );

      final result = await getCurrentWeatherUseCase.execute(testCityName);

      expect(result, const Right(testWeatherDetail));
    },
  );
}
