import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/features/cases_list_screen/data/data_sources/case_local_data_source.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/case_model.dart';

class CaseLocalDataSourceImpl implements CaseLocalDataSource {
  final SharedPreferences _prefs;
  const CaseLocalDataSourceImpl(this._prefs);

  @override
  Future<CaseModel> loadCase(String caseId) async {
    final raw = await rootBundle.loadString('assets/data/cases/easy/$caseId.json');
    return CaseModel.fromJson(json.decode(raw));
  }

  @override
  Future<List<CaseModel>> loadAllCases() async {
    final indexRaw = await rootBundle.loadString('assets/data/cases/easy/cases_index.json');
    final List<dynamic> files = json.decode(indexRaw);
    final List<CaseModel> cases = [];
    for (final f in files) {
      final raw = await rootBundle.loadString('assets/data/cases/easy/$f');
      cases.add(CaseModel.fromJson(json.decode(raw)));
    }
    return cases;
  }
}
