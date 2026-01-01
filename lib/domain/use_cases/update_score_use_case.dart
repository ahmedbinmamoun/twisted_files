import 'package:twisted_files/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';

class UpdateScoreUseCase {
  final ScoreRepository repository;

  UpdateScoreUseCase(this.repository);

  CaseDifficultyEntity _parseDifficulty(dynamic diff) {
    if (diff is CaseDifficultyEntity) return diff;
    if (diff is String) {
      switch (diff.toLowerCase()) {
        case 'easy':
          return CaseDifficultyEntity.easy;
        case 'medium':
        case 'normal':
          return CaseDifficultyEntity.medium;
        case 'hard':
        case 'difficult':
          return CaseDifficultyEntity.hard;
        default:
          return CaseDifficultyEntity.easy; 
      }
    }
    return CaseDifficultyEntity.easy;
  }

  Future<ScoreEntity> call({
    required ScoreEntity currentScore,
    required bool solvedQuestion,
    required bool solvedSuspect,
    required bool wrongQuestion, 
    required CaseEntity caseEntity,
  }) async {
    final difficulty = _parseDifficulty(caseEntity.difficulty);
    int multiplier = difficultyMultiplier(difficulty);

    int questionPoints = currentScore.questionPoints;
    int suspectPoints = currentScore.suspectPoints;
    int totalScore = currentScore.totalScore;

    if (solvedQuestion) {
      final add = 10 * multiplier;
      questionPoints += add;
      totalScore += add;
    }

    if (wrongQuestion) {
      final penalty = 5 * multiplier;
      questionPoints -= penalty;
      totalScore -= penalty;

      if (questionPoints < 0) questionPoints = 0;
      if (totalScore < 0) totalScore = 0;
    }

    if (solvedSuspect) {
      final add = 50 * multiplier;
      suspectPoints += add;
      totalScore += add;
    }

    final updatedScore = ScoreEntity(
      totalScore: totalScore,
      questionPoints: questionPoints,
      suspectPoints: suspectPoints,
    );

    await repository.saveScore(updatedScore);

    return updatedScore;
  }
}