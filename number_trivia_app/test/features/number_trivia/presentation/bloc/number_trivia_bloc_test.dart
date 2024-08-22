import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/error/failures.dart';
import 'package:number_trivia_app/core/usecases/usecase.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Initial', () async {
    expect(bloc.state, equals(NumberTriviaInitialState));
  });

  group('GetTriviaForConcreteNumber ', () {
    final tNumberString = '1';
    final tNumberParser = 1;
    final tNumberTrivia = const NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(Right(tNumberParser));

    test('should call the InputConverter to validate and convert the string to a unsigned integer', () async {
      setUpMockInputConverterSuccess();

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(tNumberString));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when input is invalid', () async* {
      when(mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(Left(InvalidInputFailure()));

      final expected = [NumberTriviaInitialState(), const NumberTriviaErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(Params(number: tNumberParser))).thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(Params(number: tNumberParser)));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParser)));
    });

    test('should mit [Loading, Loaded] when data is gotten successuffully', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(Params(number: tNumberParser))).thenAnswer(
        (_) async => Right(tNumberTrivia),
      );

      final expexted = [
        NumberTriviaInitialState(),
        NumberTriviaLoadingState(),
        NumberTriviaLoadedState(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expexted));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should mit [Loading, Error] with a proper message for the error when getting data fails', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(Params(number: tNumberParser))).thenAnswer(
        (_) async => Left(ServerFailure()),
      );

      final expexted = [
        NumberTriviaInitialState(),
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expexted));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should mit [Loading, Error] with a proper message for the error when getting data fails', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(Params(number: tNumberParser))).thenAnswer(
        (_) async => Left(CacheFailure()),
      );

      final expexted = [
        NumberTriviaInitialState(),
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expexted));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber ', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should mit [Loading, Loaded] when data is gotten successuffully', () async {
      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer(
        (_) async => const Right(tNumberTrivia),
      );

      final expexted = [
        NumberTriviaInitialState(),
        NumberTriviaLoadingState(),
        const NumberTriviaLoadedState(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expexted));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should mit [Loading, Error] with a proper message for the error when getting data fails', () async {
      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer(
        (_) async => Left(ServerFailure()),
      );

      final expexted = [
        NumberTriviaInitialState(),
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expexted));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should mit [Loading, Error] with a proper message for the error when getting data fails', () async {
      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer(
        (_) async => Left(CacheFailure()),
      );

      final expexted = [
        NumberTriviaInitialState(),
        NumberTriviaLoadingState(),
        const NumberTriviaErrorState(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expexted));

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
