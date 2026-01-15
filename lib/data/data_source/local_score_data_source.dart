import 'package:twisted_files/data/models/case_progress_model.dart';

abstract class LocalScoreDataSource {
  Future<int> getScore();
  Future<void> saveScore(int score);

  Future<int> getCaseScore(String caseId);
  Future<void> saveCaseScore(String caseId, int score);

  Future<bool?> getCaseCompleted(String caseId);

  Future<void> saveCaseProgress(CaseProgressModel model);
  Future<List<CaseProgressModel>> getAllCompletedCases();

  Future<void> resetCase(String caseId);
}