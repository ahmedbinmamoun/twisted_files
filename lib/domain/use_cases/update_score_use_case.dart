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

  int difficultyMultiplier(CaseDifficultyEntity difficulty) {
    switch (difficulty) {
      case CaseDifficultyEntity.easy: return 1;
      case CaseDifficultyEntity.medium: return 2;
      case CaseDifficultyEntity.hard: return 3;
    }
  }

  Future<ScoreEntity> call({
    required ScoreEntity currentScore,
    required bool solvedQuestion,
    required bool solvedSuspect,
    required bool wrongQuestion,
    required CaseEntity caseEntity,
  }) async {
    final difficulty = _parseDifficulty(caseEntity.difficulty);
    final multiplier = difficultyMultiplier(difficulty);

    int questionPoints = currentScore.questionPoints;
    int suspectPoints = currentScore.suspectPoints;
    int totalScore = currentScore.totalScore;

    if (solvedQuestion) {
      questionPoints += 10 * multiplier;
      totalScore += 10 * multiplier;
    }

    if (wrongQuestion) {
      final penalty = 20 * multiplier;
      questionPoints = (questionPoints - penalty).clamp(0, double.infinity).toInt();
      totalScore = (totalScore - penalty).clamp(0, double.infinity).toInt();
    }

    if (solvedSuspect) {
      suspectPoints += 50 * multiplier;
      totalScore += 50 * multiplier;
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