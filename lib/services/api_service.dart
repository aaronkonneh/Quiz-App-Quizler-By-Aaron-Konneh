import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/question.dart';
import '../models/quiz_settings.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api_category.php'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['trivia_categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Question>> getQuestions(QuizSettings settings) async {
    final queryParameters = settings.toQueryParameters();
    final uri = Uri.parse('$_baseUrl/api.php').replace(queryParameters: queryParameters);
    
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['response_code'] == 0) {
        return (data['results'] as List)
            .map((question) => Question.fromJson(question))
            .toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } else {
      throw Exception('Failed to load questions');
    }
  }
}