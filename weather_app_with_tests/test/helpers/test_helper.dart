import 'package:mockito/annotations.dart';
import 'package:weather_app_with_tests/features/domain/repositories/weather_repository.dart';
import 'package:weather_app_with_tests/features/data/datasource/remote_data_source.dart';
import 'package:weather_app_with_tests/features/domain/usecase/get_current_weather.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    WeatherRepository,
    WeatheRemoteDataSource,
    GetCurrentWeatherUseCase,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
