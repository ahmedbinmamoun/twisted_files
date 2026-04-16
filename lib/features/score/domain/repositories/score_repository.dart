import 'package:twisted_files/features/score/domain/entities/score_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_progress_entity.dart';

/// Contract for persisting and retrieving score data.
/// Follows ISP: only score-related operations live here.
abstract class ScoreRepository {
  Future<ScoreEntity> getScore();
  Future<void> saveScore(ScoreEntity score);

  Future<CaseProgressEntity?> getCaseProgress(String caseId);
  Future<void> saveCaseProgress(CaseProgressEntity progress);
  Future<void> resetCase(String caseId);
  Future<List<CaseProgressEntity>> getAllCompletedCases();
}
