import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_with_tests/features/presentation/pages/weather_page.dart';
import 'package:weather_app_with_tests/injection_container.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<WeatherBloc>())],
      child: const MaterialApp(
        home: WeatherPage(),
      ),
    );
  }
}
