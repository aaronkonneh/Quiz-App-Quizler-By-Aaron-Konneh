import 'package:flutter/material.dart';
import '../models/question.dart';
import 'setup_screen.dart';

class SummaryScreen extends StatelessWidget {
  final List<Question> questions;
  final List<bool> answers;
  final int score;

  const SummaryScreen({
    super.key,
    required this.questions,
    required this.answers,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aaron's Trivia - Summary"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Final Score',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '$score/${questions.length}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      '${(score / questions.length * 100).round()}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final correct = answers[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListTile(
                    title: Text(question.question),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Correct Answer: ${question.correctAnswer}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        if (!correct)
                          const Text(
                            'Your answer was incorrect',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    leading: Icon(
                      correct ? Icons.check_circle : Icons.cancel,
                      color: correct ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const SetupScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('New Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}