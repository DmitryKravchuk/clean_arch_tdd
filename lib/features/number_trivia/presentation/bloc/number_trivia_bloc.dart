import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_redux/core/error/failures.dart';
import 'package:flutter_app_redux/core/usecases/usecase.dart';
import 'package:flutter_app_redux/core/util/input_converter.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'number_trivia_event.dart';
import 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  @override
  NumberTriviaState get initialState => Empty();

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required InputConverter inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = inputConverter;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
        yield* _eitherLoaderOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoaderOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoaderOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold((failure) {
      return Error(message: _mapFailureToMessage(failure));
    }, (data) {
      return Loaded(trivia: data);
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
