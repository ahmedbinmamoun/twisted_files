import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/features/profile_screen/domain/entities/profile_stats_entity.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

/// SRP: Only responsible for computing profile statistics from completed cases.
class GetProfileStatsUseCase {
  final ScoreRepository _repository;
  const GetProfileStatsUseCase(this._repository);

  Future<ProfileStatsEntity> call() async {
    final cases = await _repository.getAllCompletedCases();
    int easy = 0, medium = 0, hard = 0;
    for (final c in cases) {
      if (!c.completed) continue;
      switch (c.difficulty) {
        case CaseDifficultyEntity.easy:   easy++;   break;
        case CaseDifficultyEntity.medium: medium++; break;
        case CaseDifficultyEntity.hard:   hard++;   break;
      }
    }
    return ProfileStatsEntity(easySolved: easy, mediumSolved: medium, hardSolved: hard);
  }
}
