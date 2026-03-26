class QuestionEntity {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? hint;

  const QuestionEntity({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
  });
}
