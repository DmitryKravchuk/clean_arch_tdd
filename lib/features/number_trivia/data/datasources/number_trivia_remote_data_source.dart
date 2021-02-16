import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app_redux/core/error/exceptions.dart';
import 'package:flutter_app_redux/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  Future<NumberTriviaModel> _getTriviaFromURL(String url) async {
    final response = await client.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException('some test');
    }
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async => _getTriviaFromURL('http://numberapi'
      '.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async => _getTriviaFromURL('http://numberapi.com/random');
}
