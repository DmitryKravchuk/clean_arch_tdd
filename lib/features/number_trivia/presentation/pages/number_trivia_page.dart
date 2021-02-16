import 'package:flutter/material.dart';
import 'package:flutter_app_redux/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Number Trivia'),
        ),
        body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
        builder: (_) => sl<NumberTriviaBloc>(),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
            )
          ],
        ));
  }
}
