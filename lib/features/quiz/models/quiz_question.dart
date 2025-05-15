import 'dart:developer';

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final int points;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.points,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    log('Creating QuizQuestion from JSON: ${json['id']}');
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      points: json['points'],
    );
  }
}