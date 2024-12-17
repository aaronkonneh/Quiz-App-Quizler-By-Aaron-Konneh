import 'package:flutter/material.dart';

class QuizProgressIndicator extends StatelessWidget {
  final int current;
  final int total;

  const QuizProgressIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: current / total,
        ),
        const SizedBox(height: 8),
        Text(
          'Question $current of $total',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}