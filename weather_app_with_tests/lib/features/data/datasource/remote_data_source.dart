import 'dart:convert';

import 'package:weather_app_with_tests/core/constants/constants.dart';
import 'package:weather_app_with_tests/core/error/exception.dart';
import 'package:weather_app_with_tests/features/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatheRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
}

class WeatherRemoteDataSourceImpl extends WeatheRemoteDataSource {
  final http.Client client;
  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final response = await client.get(Uri.parse(Urls.currentWeatherByName(cityName)));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
