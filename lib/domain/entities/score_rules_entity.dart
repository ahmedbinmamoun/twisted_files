class ScoreRulesEntity {
  final int questionCorrect;
  final int questionWrong;
  final int suspectCorrect;
  final int suspectWrong;

  ScoreRulesEntity({
    required this.questionCorrect,
    required this.questionWrong,
    required this.suspectCorrect,
    required this.suspectWrong
  });
}