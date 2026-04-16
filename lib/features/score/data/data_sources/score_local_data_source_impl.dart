import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/case_progress_model.dart';
import 'score_local_data_source.dart';

class ScoreLocalDataSourceImpl implements ScoreLocalDataSource {
  final SharedPreferences _prefs;

  const ScoreLocalDataSourceImpl(this._prefs);

  static const _scoreKey  = 'total_score';
  static const _casesKey  = 'cases_progress';

  @override
  Future<int> getScore() async => _prefs.getInt(_scoreKey) ?? 0;

  @override
  Future<void> saveScore(int score) async =>
      await _prefs.setInt(_scoreKey, score);

  @override
  Future<void> saveCaseProgress(CaseProgressModel model) async {
    final list = _readCases();
    list.removeWhere((e) => e.caseId == model.caseId);
    list.add(model);
    await _prefs.setString(
      _casesKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<CaseProgressModel>> getAllCompletedCases() async {
    return _readCases().where((e) => e.completed).toList();
  }

  @override
  Future<void> resetCase(String caseId) async {
    final list = _readCases();
    list.removeWhere((e) => e.caseId == caseId);
    await _prefs.setString(
      _casesKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  List<CaseProgressModel> _readCases() {
    final raw = _prefs.getString(_casesKey);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => CaseProgressModel.fromJson(e)).toList();
  }
}
