import 'package:dartz/dartz.dart';
import 'package:flutter_app_redux/core/error/failures.dart';
import 'package:flutter_app_redux/core/usecases/usecase.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_app_redux/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  // api.com/42
  // api.com/random
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
