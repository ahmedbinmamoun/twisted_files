import 'package:twisted_files/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';

abstract class ScoreRepository {
  Future<ScoreEntity> getScore();
  Future<void> saveScore(ScoreEntity score);

  Future<CaseProgressEntity?> getCaseProgress(String caseId);
  Future<void> saveCaseProgress(CaseProgressEntity progress);

  Future<void> resetCase(String caseId);

  Future<List<CaseProgressEntity>> getAllCompletedCases();
}