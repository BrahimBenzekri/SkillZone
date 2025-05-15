import 'dart:developer';

import 'quiz_question.dart';

class Quiz {
  final String id;
  final String courseId;
  final String title;
  final List<QuizQuestion> questions;
  final int totalPoints;
  final Duration timePerQuestion;

  Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.questions,
    required this.timePerQuestion,
  }) : totalPoints = questions.fold(0, (sum, question) => sum + question.points);

  factory Quiz.fromJson(Map<String, dynamic> json) {
    log('Creating Quiz from JSON: ${json['id']}');
    return Quiz(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      questions: List<QuizQuestion>.from(
          json['questions'].map((x) {
            log('Creating QuizQuestion: ${x['id']}');
            return QuizQuestion.fromJson(x);
          })),
      timePerQuestion: Duration(seconds: json['timePerQuestion']),
    );
  }
}