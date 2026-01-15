import 'package:twisted_files/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/domain/entities/profile_stats_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';

class GetProfileStatsUseCase {
  
  final ScoreRepository repository;
  
  GetProfileStatsUseCase(this.repository);

  Future<ProfileStatsEntity> call() async{
    final cases = await repository.getAllCompletedCases();

    int easy = 0;
    int medium = 0;
    int hard = 0;

    for (final c in cases) {
      if(!c.completed) continue;

      switch (c.difficulty) {
        case CaseDifficultyEntity.easy:
        easy++;
          break;
        case CaseDifficultyEntity.medium:
        medium++;
          break;
        case CaseDifficultyEntity.hard:
        hard++;
          break;

      }
    }
    return ProfileStatsEntity(
      easySolved: easy,
       mediumSolved: medium,
        hardSolved: hard
        );
  }
}