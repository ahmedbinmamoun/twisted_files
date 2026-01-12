import 'package:shared_preferences/shared_preferences.dart';
import 'local_score_data_source.dart';

class LocalScoreDataSourceImpl implements LocalScoreDataSource {
  final SharedPreferences prefs;
  LocalScoreDataSourceImpl(this.prefs);

  static const _scoreKey = 'total_score';
  String caseScoreKey(String caseId) => 'case_score$caseId';
  String caseCompletedKey(String caseId) => 'case_completed$caseId';

  @override
  Future<int> getScore() async {
    return prefs.getInt(_scoreKey) ?? 0;
  }

  @override
  Future<void> saveScore(int score) async {
    await prefs.setInt(_scoreKey, score);
  }

  @override
  Future<int> getCaseScore(String caseId) async {
    return prefs.getInt(caseScoreKey(caseId)) ?? 0;
  }

  @override
  Future<void> saveCaseScore(String caseId, int score) async {
    await prefs.setInt(caseScoreKey(caseId), score);
  }

  @override
  Future<bool?> getCaseCompleted(String caseId) async {
    return prefs.getBool(caseCompletedKey(caseId));
  }

  @override
  Future<void> saveCaseCompleted(String caseId, bool completed) async {
    await prefs.setBool(caseCompletedKey(caseId), completed);
  }

  @override
  Future<void> resetCase(String caseId) async {
    await prefs.remove(caseScoreKey(caseId));
    await prefs.remove(caseCompletedKey(caseId));
  }
}