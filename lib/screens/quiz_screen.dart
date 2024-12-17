import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_settings.dart';
import '../services/api_service.dart';
import '../widgets/question_timer.dart';
import '../widgets/progress_indicator.dart';
import 'summary_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizSettings settings;

  const QuizScreen({super.key, required this.settings});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  List<bool> _answers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _apiService.getQuestions(widget.settings);
      setState(() {
        _questions = questions;
        _answers = List.filled(questions.length, false);
        _loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  void _handleAnswer(String answer) {
    if (_answered) return;

    final question = _questions[_currentQuestionIndex];
    final correct = answer == question.correctAnswer;

    setState(() {
      _answered = true;
      _answers[_currentQuestionIndex] = correct;
      if (correct) _score++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
        });
      } else {
        _showSummary();
      }
    });
  }

  void _handleTimeout() {
    if (_answered) return;
    
    setState(() {
      _answered = true;
      _answers[_currentQuestionIndex] = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
        });
      } else {
        _showSummary();
      }
    });
  }

  void _showSummary() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          questions: _questions,
          answers: _answers,
          score: _score,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Aaron's Trivia - Question ${_currentQuestionIndex + 1}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            QuizProgressIndicator(
              current: _currentQuestionIndex + 1,
              total: _questions.length,
            ),
            const SizedBox(height: 16),
            QuestionTimer(
              duration: const Duration(seconds: 15),
              onTimeout: _handleTimeout,
              key: ValueKey(_currentQuestionIndex),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      question.question,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ...question.allAnswers.map((answer) {
                      final bool isCorrect = answer == question.correctAnswer;
                      Color? buttonColor;
                      if (_answered) {
                        buttonColor = isCorrect ? Colors.green : Colors.red;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton(
                          onPressed: _answered ? null : () => _handleAnswer(answer),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                          ),
                          child: Text(answer),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Score: $_score/${_questions.length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}