import 'package:twisted_files/data/data_source/local_score_data_source.dart';
import 'package:twisted_files/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';

class ScoreRepositoryImpl implements ScoreRepository {
  final LocalScoreDataSource localDataSource;
  ScoreRepositoryImpl(this.localDataSource);

  @override
  Future<ScoreEntity> getScore() async {
    final total = await localDataSource.getScore();
    return ScoreEntity(
      totalScore: total,
      questionPoints: 0,
      suspectPoints: 0,
    );
  }

  @override
  Future<void> saveScore(ScoreEntity score) async {
    await localDataSource.saveScore(score.totalScore);
  }

  @override
  Future<int> getCaseScore(String caseId) async {
    return await localDataSource.getCaseScore(caseId);
  }

  @override
  Future<void> saveCaseScore(String caseId, int score) async {
    await localDataSource.saveCaseScore(caseId, score);
  }

  @override
  Future<CaseProgressEntity?> getCaseProgress(String caseId) async {
    final completed = await localDataSource.getCaseCompleted(caseId);
    if (completed == null) return null;

    final score = await getCaseScore(caseId);
    return CaseProgressEntity(
      caseId: caseId,
      completed: completed,
      caseScore: score,
    );
  }

  @override
  Future<void> saveCaseProgress(CaseProgressEntity progress) async {
    await localDataSource.saveCaseScore(progress.caseId, progress.caseScore);
    await localDataSource.saveCaseCompleted(progress.caseId, progress.completed);
  }

  @override
  Future<void> resetCase(String caseId) async {
    await localDataSource.resetCase(caseId);
  }
}