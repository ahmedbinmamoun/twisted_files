import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/data/models/case_progress_model.dart';
import 'local_score_data_source.dart';

class LocalScoreDataSourceImpl implements LocalScoreDataSource {
  final SharedPreferences prefs;
  LocalScoreDataSourceImpl(this.prefs);

  static const _scoreKey = 'total_score';
  static const _casesKey = 'cases_progress';
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
  Future<void> resetCase(String caseId) async {
    await prefs.remove(caseScoreKey(caseId));
    await prefs.remove(caseCompletedKey(caseId));
  }

 @override
Future<void> saveCaseProgress(CaseProgressModel model) async {
  final list = _getAllCases();

  list.removeWhere((e) => e.caseId == model.caseId);
  list.add(model);

  await prefs.setString(
    _casesKey,
    jsonEncode(list.map((e) => e.toJson()).toList()),
  );
}

@override
Future<List<CaseProgressModel>> getAllCompletedCases() async {
  final list = _getAllCases();
  return list.where((e) => e.completed).toList();
}

List<CaseProgressModel> _getAllCases() {
    final jsonString = prefs.getString(_casesKey);
    if (jsonString == null) return [];

    final List decoded = json.decode(jsonString);
    return decoded
        .map((e) => CaseProgressModel.fromJson(e))
        .toList();
  }

 
}