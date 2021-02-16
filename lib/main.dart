import 'package:flutter/material.dart';
import 'package:flutter_app_redux/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Number Trivia App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: NumberTriviaPage());
  }
}
