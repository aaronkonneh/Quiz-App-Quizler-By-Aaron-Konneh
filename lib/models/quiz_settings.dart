class QuizSettings {
  final int numberOfQuestions;
  final int? categoryId;
  final String difficulty;
  final String type;

  QuizSettings({
    required this.numberOfQuestions,
    this.categoryId,
    required this.difficulty,
    required this.type,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'amount': numberOfQuestions.toString(),
      if (categoryId != null) 'category': categoryId.toString(),
      'difficulty': difficulty.toLowerCase(),
      'type': type,
    };
  }
}