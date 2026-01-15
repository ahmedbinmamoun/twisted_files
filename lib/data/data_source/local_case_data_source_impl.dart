import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/data/models/case_model.dart';
import 'package:twisted_files/data/data_source/local_case_data_source.dart';
import 'package:twisted_files/data/models/case_progress_model.dart';

class LocalCaseDataSourceImpl implements LocalCaseDataSource {
  final SharedPreferences prefs;
  LocalCaseDataSourceImpl(this.prefs);
  static const _casesKey = 'cases_progress';
  @override
  Future<CaseModel> loadCase(String caseId) async {
    final jsonString = await rootBundle.loadString('assets/data/cases/easy/$caseId.json');
    final jsonMap = json.decode(jsonString);
    return CaseModel.fromJson(jsonMap);
  }

  @override
  Future<List<CaseModel>> loadAllCases() async {
    final indexString = await rootBundle.loadString('assets/data/cases/easy/cases_index.json');
    final List<dynamic> files = json.decode(indexString);

    List<CaseModel> cases = [];

    for (var fileName in files) {
      final jsonString = await rootBundle.loadString('assets/data/cases/easy/$fileName');
      final jsonMap = json.decode(jsonString);
      cases.add(CaseModel.fromJson(jsonMap));
    }

    return cases;
  }

  

Future<List<CaseProgressModel>> _getAllCases() async {
  final jsonString = prefs.getString(_casesKey);
  if (jsonString == null) return [];

  final List decoded = jsonDecode(jsonString);
  return decoded.map((e) => CaseProgressModel.fromJson(e)).toList();
}

@override
Future<void> saveCaseProgress(CaseProgressModel model) async {
  final list = await _getAllCases();

  list.removeWhere((e) => e.caseId == model.caseId);
  list.add(model);

  await prefs.setString(
    _casesKey,
    jsonEncode(list.map((e) => e.toJson()).toList()),
  );
}

@override
Future<List<CaseProgressModel>> getAllCompletedCases() async {
  final list = await _getAllCases();
  return list.where((e) => e.completed).toList();
}
  
}