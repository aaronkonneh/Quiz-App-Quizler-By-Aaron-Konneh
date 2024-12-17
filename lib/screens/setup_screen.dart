import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/quiz_settings.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final ApiService _apiService = ApiService();
  List<Category> _categories = [];

  int _numberOfQuestions = 10;
  Category? _selectedCategory;
  String _difficulty = 'easy';
  String _type = 'multiple';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
    }
  }

  void _startQuiz() {
    final settings = QuizSettings(
      numberOfQuestions: _numberOfQuestions,
      categoryId: _selectedCategory?.id,
      difficulty: _difficulty,
      type: _type,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizScreen(settings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aaron's Trivia Setup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Number of Questions: $_numberOfQuestions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: _numberOfQuestions.toDouble(),
                      min: 5,
                      max: 20,
                      divisions: 3,
                      label: _numberOfQuestions.toString(),
                      onChanged: (value) {
                        setState(() {
                          _numberOfQuestions = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<Category>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                  ),
                  value: _difficulty,
                  items: ['easy', 'medium', 'hard'].map((difficulty) {
                    return DropdownMenuItem(
                      value: difficulty,
                      child: Text(difficulty.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _difficulty = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Question Type',
                  ),
                  value: _type,
                  items: const [
                    DropdownMenuItem(
                      value: 'multiple',
                      child: Text('Multiple Choice'),
                    ),
                    DropdownMenuItem(
                      value: 'boolean',
                      child: Text('True/False'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _startQuiz,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Start Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
