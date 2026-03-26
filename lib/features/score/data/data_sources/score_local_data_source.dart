import 'package:twisted_files/features/cases_list_screen/data/models/case_progress_model.dart';

/// DIP: High-level modules depend on this abstraction, not on SharedPreferences directly.
abstract class ScoreLocalDataSource {
  Future<int> getScore();
  Future<void> saveScore(int score);
  Future<void> saveCaseProgress(CaseProgressModel model);
  Future<List<CaseProgressModel>> getAllCompletedCases();
  Future<void> resetCase(String caseId);
}
