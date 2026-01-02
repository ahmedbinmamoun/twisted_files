import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/data/data_source/local_score_data_source.dart';

class LocalScoreDataSourceImpl implements LocalScoreDataSource {
  final SharedPreferences prefs;
  LocalScoreDataSourceImpl(this.prefs);

  static const _scoreKey = 'total_score';
  String _caseKey(String caseId) => 'case_score_$caseId';

  @override
  Future<int> getScore() async {
    final value = prefs.getInt(_scoreKey) ?? 0;
    print('DEBUG: getScore -> $value');
    return value;
  }

  @override
  Future<void> saveScore(int score) async {
    await prefs.setInt(_scoreKey, score);
    print('DEBUG: saveScore -> ${prefs.getInt(_scoreKey)}');
  }

  @override
  Future<void> resetScore() async {
    await prefs.remove(_scoreKey);
    print('DEBUG: resetScore');
  }

  @override
  Future<int> getCaseScore(String caseId) async {
    final v = prefs.getInt(_caseKey(caseId)) ?? 0;
    print('DEBUG: getCaseScore($caseId) -> $v');
    return v;
  }

  @override
  Future<void> saveCaseScore(String caseId, int score) async {
    await prefs.setInt(_caseKey(caseId), score);
    print('DEBUG: saveCaseScore($caseId) -> ${prefs.getInt(_caseKey(caseId))}');
  }
}