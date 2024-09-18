import 'package:get_it/get_it.dart';
import 'package:weather_app_with_tests/features/data/datasource/remote_data_source.dart';
import 'package:weather_app_with_tests/features/data/repositories/weather_repository_impl.dart';
import 'package:weather_app_with_tests/features/domain/repositories/weather_repository.dart';
import 'package:weather_app_with_tests/features/domain/usecase/get_current_weather.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void setupLocator() {
  sl.registerFactory(() => WeatherBloc(sl()));

  sl.registerLazySingleton(() => GetCurrentWeatherUseCase(sl()));

  sl.registerLazySingleton<WeatherRepository>(() => WeatherRepositoryImpl(weatheRemoteDataSource: sl()));

  sl.registerLazySingleton<WeatheRemoteDataSource>(() => WeatherRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton(() => http.Client());
}
