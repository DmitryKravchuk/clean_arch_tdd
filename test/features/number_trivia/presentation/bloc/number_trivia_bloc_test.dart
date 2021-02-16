import 'package:dartz/dartz.dart';
import 'package:flutter_app_redux/core/error/failures.dart';
import 'package:flutter_app_redux/core/usecases/usecase.dart';
import 'package:flutter_app_redux/core/util/input_converter.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_app_redux/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_app_redux/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_app_redux/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia, random: mockGetRandomNumberTrivia, inputConverter: mockInputConverter);
  });

  test(
    'initial state should be Empty',
    () async {
      // assert
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when a proper message for the error when getting data fails', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when a proper message for the error when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
