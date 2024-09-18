import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app_with_tests/features/domain/entities/weather.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_bloc.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_event.dart';
import 'package:weather_app_with_tests/features/presentation/bloc/weather_state.dart';
import 'package:weather_app_with_tests/features/presentation/pages/weather_page.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState> implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    HttpOverrides.global = null;
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>(
      create: ((context) => mockWeatherBloc),
      child: MaterialApp(home: body),
    );
  }

  const testWeatherEntity = WeatherEntity(
    cityName: 'Nur-Sultan',
    main: 'Clear',
    description: 'clear sky',
    iconCode: "01n",
    temperature: 274.12,
    pressure: 1033,
    humidity: 86,
  );

  testWidgets(
    'text field should trigger state of change from empty to loading',
    (widgetTester) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoadingState());

      await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
      var textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await widgetTester.enterText(textField, 'Astana');
      await widgetTester.pump();
      expect(find.text('Astana'), findsOneWidget);
    },
  );

  testWidgets(
    'should show progress indicator when state is loading',
    (widgetTester) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoadingState());

      await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
      var circularIndicator = find.byType(CircularProgressIndicator);
      expect(circularIndicator, findsOneWidget);
    },
  );

  testWidgets(
    'should show widget contain weather when state is weather loaded',
    (widgetTester) async {
      when(() => mockWeatherBloc.state).thenReturn(const WeatherLoadedState(testWeatherEntity));

      await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));

      expect(find.byKey(const Key('weather_data')), findsOneWidget);
    },
  );
}
