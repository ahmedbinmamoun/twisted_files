import 'package:twisted_files/features/cases_list_screen/domain/entities/question_entity.dart';

class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? hint;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    id: json['id'],
    question: json['question'],
    options: List<String>.from(json['options']),
    correctAnswer: json['correct_answer'],
    hint: json['hint'],
  );

  QuestionEntity toEntity() => QuestionEntity(
    id: id,
    question: question,
    options: options,
    correctAnswer: correctAnswer,
    hint: hint,
  );
}
