import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({@required this.text, this.number}) : super([text, number]);
}
