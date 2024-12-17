import 'package:flutter/material.dart';
import 'package:trivia_app/screens/setup_screen.dart';

void main() {
  runApp(const TriviaApp());
}

class TriviaApp extends StatelessWidget {
  const TriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aaron's Trivia",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SetupScreen(),
    );
  }
}