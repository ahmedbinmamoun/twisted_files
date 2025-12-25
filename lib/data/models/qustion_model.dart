import 'package:twisted_files/domain/entities/question_entity.dart';

class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      question: question,
      options: options,
      correctAnswer: correctAnswer,
    );
  }
}