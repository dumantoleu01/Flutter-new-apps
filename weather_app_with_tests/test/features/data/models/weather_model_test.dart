import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_with_tests/features/data/models/weather_model.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';

import '../../../helpers/json_reader.dart';

void main() {
  const testWeatherModel = WeatherModel(
    cityName: 'Nur-Sultan',
    main: 'Clear',
    description: 'clear sky',
    iconCode: "01n",
    temperature: 274.12,
    pressure: 1033,
    humidity: 86,
  );
  test(
    'should be a subclass of weather entity',
    () async {
      expect(testWeatherModel, isA<WeatherEntity>());
    },
  );

  test(
    'should return valid model from json',
    () async {
      final Map<String, dynamic> jsonMap = json.decode(readJson('helpers/dummy_data/dummy_weather_response.json'));

      final result = WeatherModel.fromJson(jsonMap);

      expect(result, testWeatherModel);
    },
  );

  test(
    'should return json map containing proper data',
    () async {
      final result = testWeatherModel.toJson();

      final expectedJdonMap = {
        'weather': [
          {
            'main': 'Clear',
            'description': 'clear sky',
            'icon': "01n",
          }
        ],
        'main': {
          'temp': 274.12,
          'pressure': 1033,
          'humidity': 86,
        }
      };

      expect(result, equals(expectedJdonMap));
    },
  );
}
