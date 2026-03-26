import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/features/score/domain/entities/score_entity.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

/// SRP: Only responsible for computing and persisting updated score.
class UpdateScoreUseCase {
  final ScoreRepository _repository;

  const UpdateScoreUseCase(this._repository);

  CaseDifficultyEntity _parseDifficulty(dynamic diff) {
    if (diff is CaseDifficultyEntity) return diff;
    if (diff is String) {
      switch (diff.toLowerCase()) {
        case 'easy':   return CaseDifficultyEntity.easy;
        case 'medium':
        case 'normal': return CaseDifficultyEntity.medium;
        case 'hard':
        case 'difficult': return CaseDifficultyEntity.hard;
        default:       return CaseDifficultyEntity.easy;
      }
    }
    return CaseDifficultyEntity.easy;
  }

  int _difficultyMultiplier(CaseDifficultyEntity d) {
    switch (d) {
      case CaseDifficultyEntity.easy:   return 1;
      case CaseDifficultyEntity.medium: return 2;
      case CaseDifficultyEntity.hard:   return 3;
    }
  }

  Future<ScoreEntity> call({
    required ScoreEntity currentScore,
    required bool solvedQuestion,
    required bool solvedSuspect,
    required bool wrongQuestion,
    required CaseEntity caseEntity,
  }) async {
    final multiplier = _difficultyMultiplier(_parseDifficulty(caseEntity.difficulty));
    int q = currentScore.questionPoints;
    int s = currentScore.suspectPoints;
    int t = currentScore.totalScore;

    if (solvedQuestion) { q += 10 * multiplier; t += 10 * multiplier; }
    if (wrongQuestion)  { final p = 20 * multiplier; q = (q - p).clamp(0, double.infinity).toInt(); t = (t - p).clamp(0, double.infinity).toInt(); }
    if (solvedSuspect)  { s += 50 * multiplier; t += 50 * multiplier; }

    return ScoreEntity(totalScore: t, questionPoints: q, suspectPoints: s);
  }
}
